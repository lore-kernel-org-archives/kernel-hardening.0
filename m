MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170328234650.19695-10-mic@digikod.net>
References: <20170328234650.19695-1-mic@digikod.net> <20170328234650.19695-10-mic@digikod.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Apr 2017 17:02:57 -0700
Message-ID: <CAGXu5j+D-FP8Kt9unNOqKrQJP4DYTpmgkJxWykZyrYiVPz3Y3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH net-next v6 09/11] seccomp: Enhance test_harness with an
 assert step mechanism
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Matthew Garrett <mjg59@srcf.ucam.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 28, 2017 at 4:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
> This is useful to return an information about the error without being
> able to write to TH_LOG_STREAM.
>
> Helpers from test_harness.h may be useful outside of the seccomp
> directory.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Will Drewry <wad@chromium.org>
> ---
>  tools/testing/selftests/seccomp/test_harness.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/seccomp/test_harness.h b/tools/testi=
ng/selftests/seccomp/test_harness.h
> index a786c69c7584..77e407663e06 100644
> --- a/tools/testing/selftests/seccomp/test_harness.h
> +++ b/tools/testing/selftests/seccomp/test_harness.h
> @@ -397,7 +397,7 @@ struct __test_metadata {
>         const char *name;
>         void (*fn)(struct __test_metadata *);
>         int termsig;
> -       int passed;
> +       __s8 passed;

Why the reduction here? int is signed too?

>         int trigger; /* extra handler after the evaluation */
>         struct __test_metadata *prev, *next;
>  };
> @@ -476,6 +476,12 @@ void __run_test(struct __test_metadata *t)
>                                         "instead of by signal (code: %d)\=
n",
>                                         t->name,
>                                         WEXITSTATUS(status));
> +                       } else if (t->passed < 0) {
> +                               fprintf(TH_LOG_STREAM,
> +                                       "%s: Failed at step #%d\n",
> +                                       t->name,
> +                                       t->passed * -1);
> +                               t->passed =3D 0;
>                         }

Instead of creating an overloaded mechanism here, perhaps have an
option reporting mechanism that can be enabled. Like adding to
__test_metadata "bool no_stream; int test_number;" and adding
test_number++ to each ASSERT/EXCEPT call, and doing something like:

if (t->no_stream) {
                              fprintf(TH_LOG_STREAM,
                                      "%s: Failed at step #%d\n",
                                      t->name,
                                       t->test_number);
}

It'd be a cleaner approach, maybe?

-Kees

--=20
Kees Cook
Pixel Security
