MIME-Version: 1.0
References: <20180725202238.165314-1-salyzyn@android.com> <20180725210717.3b807191@vmware.local.home>
 <11437c3e-5131-7190-c496-7b51eb7fcc2a@android.com> <20180726153153.GA8327@kroah.com>
In-Reply-To: <20180726153153.GA8327@kroah.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 26 Jul 2018 09:52:11 -0700
Message-ID: <CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Content-Type: text/plain; charset="UTF-8"
To: greg@kroah.com, Kees Cook <keescook@google.com>
Cc: salyzyn@android.com, rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, kernel-team@android.com, stable@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 26, 2018 at 8:32 AM Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jul 26, 2018 at 08:14:08AM -0700, Mark Salyzyn wrote:
> > On 07/25/2018 06:07 PM, Steven Rostedt wrote:
> > > On Wed, 25 Jul 2018 13:22:36 -0700
> > > Mark Salyzyn <salyzyn@android.com> wrote:
> > >
> > > > From: Nick Desaulniers <ndesaulniers@google.com>
> > > >
> > > > Switch from 0x%lx to 0x%pK to print the kernel addresses.
> > > >
> > > > Fixes: CVE-2017-0630
> > > Wait!!!! This breaks perf and trace-cmd! They require this to be able
> > > to print various strings in trace events. This file is root read only,
> > > as the CVE says.
> > >
> > > NAK for this fix. Come up with something that doesn't break perf and
> > > trace-cmd. That will not be trivial, as the format is stored in the
> > > ring buffer with an address, then referenced directly. It also handles
> > > trace_printk() functions that simply point to the string format itself.
> > >
> > > A fix would require having a pointer be the same that is referenced
> > > inside the kernel as well as in this file. Maybe make the format string
> > > placed in a location that doesn't leak where the rest of the kernel
> > > exists?
> > >
> > > -- Steve
> > Thank you Steve, much appreciated feedback, I have asked the security
> > developers to keep this in mind and come up with a correct fix.
> >
> > The correct fix that meets your guidelines would _not_ be suitable for
> > stable due to the invasiveness it sounds, only for the latest will such a
> > rework make sense. As such, the fix proposed in this patch is the only one
> > that meets the bar for stable patch simplicity, and merely(!) needs to state
> > that if the fix is taken, perf and trace are broken.
>
> Why would I take something for the stable trees that does not match what
> is upstream?  It feels to me that this CVE is just invalid.  Yes, root
> can read the kernel address, does that mean it is a problem?  Only if
> you allow unprotected users to run with root privileges :)
>
> What exactly is the problem here in the current kernel that you are
> trying to solve?

See the section "Kernel addresses" in
Documentation/security/self-protection.  IIRC, the issue is that a
process may have CAP_SYSLOG but not necessarily CAP_SYS_ADMIN (so it
can read dmesg, but not necessarily issue a sysctl to change
kptr_restrict), get compromised and used to leak kernel addresses,
which can then be used to defeat KASLR.

-- 
Thanks,
~Nick Desaulniers
