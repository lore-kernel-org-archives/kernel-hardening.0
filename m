Date: Tue, 6 Feb 2018 22:51:32 +0000
From: Luis Henriques <lhenriques@suse.com>
Subject: Re: [PATCH v4 07/10] x86: narrow out of bounds syscalls to sys_read
 under speculation
Message-ID: <20180206225132.yewppdrnut35gzrh@hermes.olymp>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632014097.21271.16980532033566583357.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180206192925.qkmghwsbaysr4iv2@hermes.olymp>
 <CAPcyv4ihN6fy5-vBtfA0PuwXvCAj8-rMhtQmevh5sdYxbH3Yfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4ihN6fy5-vBtfA0PuwXvCAj8-rMhtQmevh5sdYxbH3Yfw@mail.gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 06, 2018 at 11:48:45AM -0800, Dan Williams wrote:
> On Tue, Feb 6, 2018 at 11:29 AM, Luis Henriques <lhenriques@suse.com> wrote:
> > On Thu, Jan 18, 2018 at 04:02:21PM -0800, Dan Williams wrote:
> >> The syscall table base is a user controlled function pointer in kernel
> >> space. Like, 'get_user, use 'MASK_NOSPEC' to prevent any out of bounds
> >> speculation. While retpoline prevents speculating into the user
> >> controlled target it does not stop the pointer de-reference, the concern
> >> is leaking memory relative to the syscall table base.
> >
> > This patch seems to cause a regression.  An easy way to reproduce what
> > I'm seeing is to run the samples/statx/test-statx.  Here's what I see
> > when I have this patchset applied:
> >
> > # ./test-statx /tmp
> > statx(/tmp) = -1
> > /tmp: Bad file descriptor
> >
> > Reverting this single patch seems to fix it.
> 
> Just to clarify, when you say "this patch" you mean:
> 
>      2fbd7af5af86 x86/syscall: Sanitize syscall table de-references
> under speculation
> 
> ...not this early MASK_NOSPEC version of the patch, right?

*sigh*

Looks like I spent some good amount of time hunting a non-issue just
because I have enough old branches hanging around to confusing me :-(

Sorry for the noise.

Cheers,
--
Luís
