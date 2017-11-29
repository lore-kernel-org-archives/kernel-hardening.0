Date: Wed, 29 Nov 2017 13:46:12 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20171129134612.72ccb53d@alans-desktop>
In-Reply-To: <CAGXu5j+JaFCo+pZKvet==Kh7GQgNXi30P50SMF4cpOGoUw-8ug@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
	<1511803118-2552-2-git-send-email-tixxdz@gmail.com>
	<20171128191405.GO729@wotan.suse.de>
	<CAGXu5jKgHWNE4NH_xqcM084-BNBPy+HmEVPbTA+w_=K3S6gC=w@mail.gmail.com>
	<20171128211659.GP729@wotan.suse.de>
	<CAGXu5j+JaFCo+pZKvet==Kh7GQgNXi30P50SMF4cpOGoUw-8ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add
 request_module_cap()
To: Kees Cook <keescook@chromium.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 28 Nov 2017 13:39:58 -0800
Kees Cook <keescook@chromium.org> wrote:

> On Tue, Nov 28, 2017 at 1:16 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > And *all* auto-loading uses aliases? What's the difference between auto-loading
> > and direct-loading?  
> 
> The difference is the process privileges. Unprivilged autoloading
> (e.g. int n_hdlc = N_HDLC; ioctl(fd,
> TIOCSETD, &n_hdlc)), triggers a privileged call to finit_module()
> under CAP_SYS_MODULE.

If you have CAP_SYS_DAC you can rename any module to ppp.ko and ask the
network manager (which has the right permissions) to init a ppp
connection. Capabilities alone are simply not enough to do any kind of
useful protection on a current system and the Linux capability model is
broken architecturally and not fixable because fixing it would break lots
of real systems.

I really don't care what the module loading rules end up with and whether
we add CAP_SYS_YET_ANOTHER_MEANINGLESS_FLAG but what is actually needed
is to properly incorporate it into securiy ruiles for whatever LSM you
are using.

Alan
