Message-ID: <1496511155.29205.109.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
In-Reply-To: <20170603113007.GA1544@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Jun 2017 13:32:35 -0400
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 2017-06-03 at 07:30 -0400, Brad Spengler wrote:

> While I'm here:
> http://openwall.com/lists/kernel-hardening/2017/06/02/3
> 
> "a value linux-hardened and grsecurity have used for a long time now"
> Rik, you're giving credit to a project that didn't even exist a
> couple
> weeks ago, yet they've somehow used it "for a long time", even though

CopperheadOS has been around for a few years now, with
a hardened Linux kernel as one of its components.

> it only exists there because it was copy+pasted from grsecurity?  Is
> that what we do now, credit plagiarists instead of the actual authors
> of
> the work?  Sorry, but the "work" of struggling to understand code
> that
> isn't yours doesn't suddenly make it your code.

The actual code in my patch is different from the #ifdef
stuff in both linux-hardened and grsecurity. 

The only thing that is the same is an integer constant.

> This is exactly how your plagiarism works.

If I wanted to do plagiarism, I would have copied the
ugly-as-all-hell #ifdef magic from grsecurity. What
do you think would have happened if I had submitted
something like this to lkml?

#ifdef CONFIG_PAX_SEGMEXEC
#define ELF_ET_DYN_BASE         ((current->mm->pax_flags &
MF_PAX_SEGMEXEC) ? SEGMEXEC_TASK_SIZE/3*2 : TASK_SIZE/3*2)
#else
#define ELF_ET_DYN_BASE         (TASK_SIZE / 3 * 2)
#endif

#ifdef CONFIG_PAX_ASLR
#ifdef CONFIG_X86_32
#define PAX_ELF_ET_DYN_BASE     0x10000000UL

#define PAX_DELTA_MMAP_LEN      (current->mm->pax_flags &
MF_PAX_SEGMEXEC ? 15 : 16)
#define PAX_DELTA_STACK_LEN     (current->mm->pax_flags &
MF_PAX_SEGMEXEC ? 15 : 16)
#else
#define PAX_ELF_ET_DYN_BASE     0x400000UL

#define PAX_DELTA_MMAP_LEN      ((test_thread_flag(TIF_ADDR32)) ? 16 :
TASK_SIZE_MAX_SHIFT - PAGE_SHIFT - 3)
#define PAX_DELTA_STACK_LEN     ((test_thread_flag(TIF_ADDR32)) ? 16 :
TASK_SIZE_MAX_SHIFT - PAGE_SHIFT - 3)
#endif
#endif

Notice how the code in my patch does not look like that,
at all?

> This is your last warning.  This is not a new problem and it needs to
> end completely, or I will make sure it ends.

The grsecurity code you published is licensed under the
GPLv2. I would be happy to add your copyright in if I
ever copied around a larger piece of code, but most of
the time the code I end up submitting is a rewrite and
not a copy.
