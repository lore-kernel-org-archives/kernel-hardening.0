Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1472121165-29071-8-git-send-email-mic@digikod.net>
References: <1472121165-29071-1-git-send-email-mic@digikod.net> <1472121165-29071-8-git-send-email-mic@digikod.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 25 Aug 2016 04:13:48 -0700
Message-ID: <CALCETrVvoX+XM_2++o-VyQ0w2_nTr6QbgdOxnvCXBFKb+qMPBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC v2 07/10] landlock: Add errno check
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 25, 2016 at 3:32 AM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
> Add a max errno value.
>
> This is not strictly needed but should improve reliability.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Kees Cook <keescook@chromium.org>
> ---
>  include/uapi/asm-generic/errno-base.h | 1 +
>  security/landlock/lsm.c               | 6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/uapi/asm-generic/errno-base.h b/include/uapi/asm-gen=
eric/errno-base.h
> index 65115978510f..43407a403e72 100644
> --- a/include/uapi/asm-generic/errno-base.h
> +++ b/include/uapi/asm-generic/errno-base.h
> @@ -35,5 +35,6 @@
>  #define        EPIPE           32      /* Broken pipe */
>  #define        EDOM            33      /* Math argument out of domain of=
 func */
>  #define        ERANGE          34      /* Math result not representable =
*/
> +#define        _ERRNO_LAST     ERANGE

At the very least this needs a more sensible name.
