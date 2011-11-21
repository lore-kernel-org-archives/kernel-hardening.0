Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20111121191811.GA24039@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<20111121191811.GA24039@albatros>
Date: Mon, 21 Nov 2011 11:42:12 -0800
Message-ID: <CAGXu5jJuoC7dgB_U2qj1Pb0-wd_D+JjLEuxS2e+uZDEugvGqXQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC] Make Yama pid_ns aware
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 21, 2011 at 11:18 AM, Vasiliy Kulikov <segoon@openwall.com> wro=
te:
> As Yama's sysctls are about defining a security policy for the system,
> it is reasonable to define it per container in case of LXC containers
> (or out-of-tree alternatives like OpenVZ). =A0In my opinion they belong
> to pid namespace. =A0With per-pid_ns sysctls it is possible to create
> multiple containers with different ptrace, /tmp, etc. policies.

Cool, this seems like a good idea. Thanks for the patch! If Serge (or
other folks thinking about per-pid_ns stuff) think this is a good
approach, I'm happy to include it in the next revision of the Yama
patchset.

> proc_pid_dointvec_minmax() is stolen from its ipc_ns equivalent in
> ipc/ipc_sysctl.c.

I wonder if this function should be moved into a common location, in
case other things will want to do similar things.

-Kees

--=20
Kees Cook
ChromeOS Security
