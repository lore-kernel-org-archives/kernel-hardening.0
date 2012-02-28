Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Feb 2012 16:13:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120228151333.GA3664@redhat.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org> <1330140111-17201-6-git-send-email-wad@chromium.org> <20120227170922.GA10608@redhat.com> <CABqD9hbtFDU_vgBOajG2jJxQoHubcwYWJuHPLjgZkZyjGkQ2uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABqD9hbtFDU_vgBOajG2jJxQoHubcwYWJuHPLjgZkZyjGkQ2uQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v11 06/12] seccomp: add system call filtering using BPF
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On 02/27, Will Drewry wrote:
>
> On Mon, Feb 27, 2012 at 11:09 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> >> +static long seccomp_attach_filter(struct sock_fprog *fprog)
> >> +{
> >> +     struct seccomp_filter *filter;
> >> +     unsigned long fp_size = fprog->len * sizeof(struct sock_filter);
> >> +     long ret;
> >> +
> >> +     if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
> >> +             return -EINVAL;
> >
> > OK, this limits the memory PR_SET_SECCOMP can use.
> >
> > But,
> >
> >> +     /*
> >> +      * If there is an existing filter, make it the prev and don't drop its
> >> +      * task reference.
> >> +      */
> >> +     filter->prev = current->seccomp.filter;
> >> +     current->seccomp.filter = filter;
> >> +     return 0;
> >
> > this doesn't limit the number of filters, looks like a DoS.
> >
> > What if the application simply does prctl(PR_SET_SECCOMP, dummy_filter)
> > in an endless loop?
>
> It consumes a massive amount of kernel memory and, maybe, the OOM
> killer gives it a boot :)

may be ;) but most probably oom-killer kills another innocent task,
this memory is not accounted.

> I wasn't sure what the normal convention was for avoiding memory
> consumption by user processes. Should I just add a sysctl

Perhaps we can add a sysctl later, but personally I think that we
can start with some "arbitrary" #define BPF_MAXFILTERS.

> and a
> per-task counter for the max number of filters?

Do we really need the counter? attach_filter is not the fast path,
perhaps seccomp_attach_filter() could simply iterate the chain and
count the number?

In any case, if this hurts perfomance-wise then seccomp_run_filters()
has even more problems.

> I'm fine doing whatever makes sense here.

I am fine either way too.

Oleg.
