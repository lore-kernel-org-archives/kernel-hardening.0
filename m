Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <4F3D7500.2070604@zytor.com>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
	<1329422549-16407-5-git-send-email-wad@chromium.org>
	<CAE6n16mCrJC=Sre+PT1H_VfSjW0MGyi0xtEcdcRvGMvvwXWzmA@mail.gmail.com>
	<CABqD9hZSLqn+=jr6sWwp_eJ5WsuGpH2Khoc_7aRmYt+1ZaEGoA@mail.gmail.com>
	<4F3D7500.2070604@zytor.com>
Date: Thu, 16 Feb 2012 15:33:47 -0600
Message-ID: <CABqD9hbW_z-x7tgnBHPqVry=XLo+HDFtAhdXKHG+fxgn6fB6_g@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v8 5/8] seccomp: Add SECCOMP_RET_TRAP
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Markus Gutschke <markus@chromium.org>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2012 at 3:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/16/2012 12:42 PM, Will Drewry wrote:
>> On Thu, Feb 16, 2012 at 2:24 PM, Markus Gutschke <markus@chromium.org> w=
rote:
>>> SIGTRAP might not be the ideal choice of signal number, as it can make =
it
>>> very difficult to debug the program in gdb.
>>
>> True enough. =A0In theory, we could use the lower 16-bits of the return
>> value to let the bpf program set a signal, but not all signals are
>> masked synchronous and those that are probably get gdb's attention,
>> just not a severely :) (ILL, SEGV, BUS, TRAP, FPE). Perhaps SIGILL is
>> a logically appropriate option -- or letting the api user decide from
>> the SYNCHRONOUS_MASK set. =A0I'm open to whatever makes sense, though.
>> (I wasn't even sure if it was kosher to add a new TRAP_SECCOMP value.)
>>
>
> There is a standard signal for this -- SIGSYS -- which happens to be
> currently unused in Linux.

Awesome.  I'll respin using that.
