Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1458784008-16277-4-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
	<1458784008-16277-4-git-send-email-mic@digikod.net>
Date: Wed, 23 Mar 2016 21:35:40 -0700
Message-ID: <CAGXu5jKArYiYi4EDw=H9Kj3DQYgD0Q51Tfwc85wCTv_TN+X03w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC v1 03/17] selftest/seccomp: Fix the flag name SECCOMP_FILTER_FLAG_TSYNC
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 23, 2016 at 6:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
> Rename SECCOMP_FLAG_FILTER_TSYNC to SECCOMP_FILTER_FLAG_TSYNC to match
> the UAPI.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>

Hah, oops. Thanks! Shuah, can you take this patch into the selftest tree?

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testin=
g/selftests/seccomp/seccomp_bpf.c
> index b9453b838162..9c1460f277c2 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -1497,8 +1497,8 @@ TEST_F(TRACE_syscall, syscall_dropped)
>  #define SECCOMP_SET_MODE_FILTER 1
>  #endif
>
> -#ifndef SECCOMP_FLAG_FILTER_TSYNC
> -#define SECCOMP_FLAG_FILTER_TSYNC 1
> +#ifndef SECCOMP_FILTER_FLAG_TSYNC
> +#define SECCOMP_FILTER_FLAG_TSYNC 1
>  #endif
>
>  #ifndef seccomp
> @@ -1613,7 +1613,7 @@ TEST(TSYNC_first)
>                 TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYN=
C,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYN=
C,
>                       &prog);
>         ASSERT_NE(ENOSYS, errno) {
>                 TH_LOG("Kernel does not support seccomp syscall!");
> @@ -1831,7 +1831,7 @@ TEST_F(TSYNC, two_siblings_with_ancestor)
>                 self->sibling_count++;
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYN=
C,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYN=
C,
>                       &self->apply_prog);
>         ASSERT_EQ(0, ret) {
>                 TH_LOG("Could install filter on all threads!");
> @@ -1892,7 +1892,7 @@ TEST_F(TSYNC, two_siblings_with_no_filter)
>                 TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYN=
C,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYN=
C,
>                       &self->apply_prog);
>         ASSERT_NE(ENOSYS, errno) {
>                 TH_LOG("Kernel does not support seccomp syscall!");
> @@ -1940,7 +1940,7 @@ TEST_F(TSYNC, two_siblings_with_one_divergence)
>                 self->sibling_count++;
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYN=
C,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYN=
C,
>                       &self->apply_prog);
>         ASSERT_EQ(self->sibling[0].system_tid, ret) {
>                 TH_LOG("Did not fail on diverged sibling.");
> @@ -1992,7 +1992,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>                 TH_LOG("Kernel does not support SECCOMP_SET_MODE_FILTER!"=
);
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYN=
C,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYN=
C,
>                       &self->apply_prog);
>         ASSERT_EQ(ret, self->sibling[0].system_tid) {
>                 TH_LOG("Did not fail on diverged sibling.");
> @@ -2021,7 +2021,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>         /* Switch to the remaining sibling */
>         sib =3D !sib;
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYN=
C,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYN=
C,
>                       &self->apply_prog);
>         ASSERT_EQ(0, ret) {
>                 TH_LOG("Expected the remaining sibling to sync");
> @@ -2044,7 +2044,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>         while (!kill(self->sibling[sib].system_tid, 0))
>                 sleep(0.1);
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYN=
C,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYN=
C,
>                       &self->apply_prog);
>         ASSERT_EQ(0, ret);  /* just us chickens */
>  }
> --
> 2.8.0.rc3
>



--=20
Kees Cook
Chrome OS & Brillo Security
