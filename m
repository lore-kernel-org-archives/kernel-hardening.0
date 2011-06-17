Reply-To: kernel-hardening@lists.openwall.com
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110617083651.GA5625@albatros>
References: <20110617083651.GA5625@albatros>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jun 2011 11:29:17 +0200
Message-ID: <1308302957.2355.5.camel@twins>
Mime-Version: 1.0
Subject: [kernel-hardening] Re: How to temporary change 'current' (task)
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2011-06-17 at 12:36 +0400, Vasiliy Kulikov wrote:
> Hi,
>=20
> I wonder whether there is a simple way to temporary switch 'current' to
> another task and then switch it back with minimum side effects?=20

No.

>  I need
> it to call "reversed" ptrace_may_access() with swapped current and
> target task.  Introducing ptrace_task_may_access_me() would produce too
> much noise in LSM (it also needs reversed security_ptrace_access_check())=
,
> which is too loud for my needs.
>=20
> Specifically, I need it to filter taskstats and proc connector requests
> for a restriction of getting other processes' information:
>=20
> http://permalink.gmane.org/gmane.linux.kernel/1155354
>=20
> As the check is handled in the context of the ptrace target process,
> ptrace_may_access() doesn't fit my needs.

looking at __ptrace_may_access() it doesn't look too hard to make it
take two task arguments and use __task_cred() twice instead of
current_cred().

It of course needs extending security_ptrace_access_check() as well, but
that comes with the territory.
