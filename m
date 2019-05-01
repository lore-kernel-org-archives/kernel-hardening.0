MIME-Version: 1.0
References: <20180208021112.GB14918@bombadil.infradead.org> <20180302212637.GB671@bombadil.infradead.org>
In-Reply-To: <20180302212637.GB671@bombadil.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 1 May 2019 10:41:11 -0400
Message-ID: <CAG48ez1G5tECsYj7wAGbgp5814BBZB1YHL20ZkeO9gvFprD=2Q@mail.gmail.com>
Subject: Re: [RFC] Handle mapcount overflows
Content-Type: text/plain; charset="UTF-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

[extremely slow reply]

On Fri, Mar 2, 2018 at 4:26 PM Matthew Wilcox <willy@infradead.org> wrote:
> Here's my third effort to handle page->_mapcount overflows.
>
> The idea is to minimise overhead, so we keep a list of users with more
> than 5000 mappings.  In order to overflow _mapcount, you have to have
> 2 billion mappings, so you'd need 400,000 tasks to evade the tracking,
> and your sysadmin has probably accused you of forkbombing the system
> long before then.  Not to mention the 6GB of RAM you consumed just in
> stacks and the 24GB of RAM you consumed in page tables ... but I digress.
>
> Let's assume that the sysadmin has increased the number of processes to
> 100,000.  You'd need to create 20,000 mappings per process to overflow
> _mapcount, and they'd end up on the 'heavy_users' list.  Not everybody
> on the heavy_users list is going to be guilty, but if we hit an overflow,
> we look at everybody on the heavy_users list and if they've got the page
> mapped more than 1000 times, they get a SIGSEGV.
>
> I'm not entirely sure how to forcibly tear down a task's mappings, so
> I've just left a comment in there to do that.  Looking for feedback on
> this approach.
[...]
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 9efdc021ad22..575766ec02f8 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
[...]
> +static void kill_mm(struct task_struct *tsk)
> +{
> +       /* Tear down the mappings first */
> +       do_send_sig_info(SIGKILL, SEND_SIG_FORCED, tsk, true);
> +}

The mapping teardown could maybe be something like
unmap_mapping_range_vma()? That doesn't remove the VMA, but it gets
rid of the PTEs; and it has the advantage of working without taking
the mmap_sem. And then it isn't even necessarily required to actually
kill the abuser; instead, the abuser would just take a minor fault on
the next access, and the abusers would take away each other's
references, slowing each other down.

> +static void kill_abuser(struct mm_struct *mm)
> +{
> +       struct task_struct *tsk;
> +
> +       for_each_process(tsk)
> +               if (tsk->mm == mm)
> +                       break;

(There can be multiple processes sharing the ->mm.)

> +       if (down_write_trylock(&mm->mmap_sem)) {
> +               kill_mm(tsk);
> +               up_write(&mm->mmap_sem);
> +       } else {
> +               do_send_sig_info(SIGKILL, SEND_SIG_FORCED, tsk, true);
> +       }

Hmm. Having to fall back if the lock is taken here is kind of bad, I
think. __get_user_pages_locked() with locked==NULL can keep the
mmap_sem blocked arbitrarily long, meaning that an attacker could
force the fallback path, right? For example, __access_remote_vm() uses
get_user_pages_remote() with locked==NULL. And IIRC you can avoid
getting killed by a SIGKILL by being stuck in unkillable disk sleep,
which I think FUSE can create by not responding to a request.

> +}
> +
> +void mm_mapcount_overflow(struct page *page)
> +{
> +       struct mm_struct *entry = current->mm;
> +       unsigned int id;
> +       struct vm_area_struct *vma;
> +       struct address_space *mapping = page_mapping(page);
> +       unsigned long pgoff = page_to_pgoff(page);
> +       unsigned int count = 0;
> +
> +       vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + 1) {

I think this needs the i_mmap_rwsem?

> +               if (vma->vm_mm == entry)
> +                       count++;
> +               if (count > 1000)
> +                       kill_mm(current);
> +       }
> +
> +       rcu_read_lock();
> +       idr_for_each_entry(&heavy_users, entry, id) {
> +               count = 0;
> +
> +               vma_interval_tree_foreach(vma, &mapping->i_mmap,
> +                               pgoff, pgoff + 1) {
> +                       if (vma->vm_mm == entry)
> +                               count++;
> +                       if (count > 1000) {
> +                               kill_abuser(entry);
> +                               goto out;

Even if someone has 1000 mappings of the range in question, that
doesn't necessarily mean that there are actually any non-zero PTEs in
the abuser. This probably needs to get some feedback from
kill_abuser() to figure out whether at least one reference has been
reclaimed.

> +                       }
> +               }
> +       }
> +       if (!entry)
> +               panic("No abusers found but mapcount exceeded\n");
> +out:
> +       rcu_read_unlock();
> +}
[...]
> @@ -1357,6 +1466,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>         /* Too many mappings? */
>         if (mm->map_count > sysctl_max_map_count)
>                 return -ENOMEM;
> +       if (mm->map_count > mm_track_threshold)
> +               mmap_track_user(mm, mm_track_threshold);

I think this check would have to be copied to a few other places;
AFAIK you can e.g. use a series of mremap() calls to create multiple
mappings of the same file page. Something like:

char *addr = mmap(0x100000000, 0x1000, PROT_READ, MAP_SHARED, fd, 0);
for (int i=0; i<1000; i++) {
  mremap(addr, 0x1000, 0x2000, 0);
  mremap(addr+0x1000, 0x1000, 0x1000, MREMAP_FIXED|MREMAP_MAYMOVE,
0x200000000 + i * 0x1000);
}

>         /* Obtain the address to map to. we verify (or select) it and ensure
>          * that it represents a valid section of the address space.
> @@ -2997,6 +3108,8 @@ void exit_mmap(struct mm_struct *mm)
>         /* mm's last user has gone, and its about to be pulled down */
>         mmu_notifier_release(mm);
>
> +       mmap_untrack_user(mm);
> +
>         if (mm->locked_vm) {
>                 vma = mm->mmap;
>                 while (vma) {

I'd move that call further down, to reduce the chance that the task
blocks after being untracked but before actually dropping its
references.
