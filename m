Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20111128191658.GA6028@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<20111128191658.GA6028@albatros>
Date: Mon, 28 Nov 2011 11:35:10 -0800
Message-ID: <CAGXu5j+=j7Gy+D0wzZ44NPAK1PYyp1gHU-GQQOBCLi4fRc9UmQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC -resend] Make Yama pid_ns aware
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 28, 2011 at 11:16 AM, Vasiliy Kulikov <segoon@openwall.com> wro=
te:
> As Yama's sysctls are about defining a security policy for the system,
> it is reasonable to define it per container in case of LXC containers
> (or out-of-tree alternatives like OpenVZ). =A0In my opinion they belong
> to pid namespace. =A0With per-pid_ns sysctls it is possible to create
> multiple containers with different ptrace, /tmp, etc. policies.
> [...]
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Thanks! I'll include this in the next Yama patch set.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

--=20
Kees Cook
ChromeOS Security
