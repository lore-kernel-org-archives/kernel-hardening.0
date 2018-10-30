MIME-Version: 1.0
In-Reply-To: <20181030152641.GE8177@hirez.programming.kicks-ass.net>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com> <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net> <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 30 Oct 2018 09:37:56 -0700
Message-ID: <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
Subject: Re: [PATCH 10/17] prmem: documentation
Content-Type: text/plain; charset="UTF-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 8:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> I suppose the 'normal' attack goes like:
>
>  1) find buffer-overrun / bound check failure
>  2) use that to write to 'interesting' location
>  3) that write results arbitrary code execution
>  4) win
>
> Of course, if the store of 2 is to the current cred structure, and
> simply sets the effective uid to 0, we can skip 3.

In most cases, yes, gaining root is game over. However, I don't want
to discount other threat models: some systems have been designed not
to trust root, so a cred attack doesn't always get an attacker full
control (e.g. lockdown series, signed modules, encrypted VMs, etc).

> Which seems to suggest all cred structures should be made r/o like this.
> But I'm not sure I remember these patches doing that.

There are things that attempt to protect cred (and other things, like
page tables) via hypervisors (see Samsung KNOX) or via syscall
boundary checking (see Linux Kernel Runtime Guard). They're pretty
interesting, but I'm not sure if there is a clear way forward on it
working in upstream, but that's why I think these discussions are
useful.

> Also, there is an inverse situation with all this. If you make
> everything R/O, then you need this allow-write for everything you do,
> which then is about to include a case with an overflow / bound check
> fail, and we're back to square 1.

Sure -- this is the fine line in trying to build these defenses. The
point is to narrow the scope of attack. Stupid metaphor follows: right
now we have only a couple walls; if we add walls we can focus on make
sure the doors and windows are safe. If we make the relatively
easy-to-find-in-memory page tables read-only-at-rest then a whole
class of very powerful exploits that depend on page table attacks go
away.

As part of all of this is the observation that there are two types of
things clearly worth protecting: that which is updated rarely (no need
to leave it writable for so much of its lifetime), and that which is
especially sensitive (page tables, security policy, function pointers,
etc). Finding a general purpose way to deal with these (like we have
for other data-lifetime cases like const and __ro_after_init) would be
very nice. I don't think there is a slippery slope here.

-Kees

-- 
Kees Cook
