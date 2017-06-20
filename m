MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 12:14:34 -0700
Message-ID: <CAGXu5jLdc7dHbjd1ZTNuc2=Bk3zTNeXd8EGT-YUcG-0gkp3+jg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v2 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 9, 2017 at 7:30 AM, Alexander Popov <alex.popov@linux.com> wrote:
> diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
> new file mode 100644
> index 0000000..2ee49c4
> --- /dev/null
> +++ b/scripts/gcc-plugins/stackleak_plugin.c
> [...]
> + * TODO:
> + * - initialize all local variables
> [...]
> +static bool init_locals;
> +
> +static struct plugin_info stackleak_plugin_info = {
> +       .version        = "201602181345",
> +       .help           = "track-lowest-sp=nn\ttrack sp in functions whose frame size is at least nn bytes\n"
> +//                       "initialize-locals\t\tforcibly initialize all stack frames\n"
> +};
> [...]
> +       for (i = 0; i < argc; ++i) {
> +               if (!strcmp(argv[i].key, "track-lowest-sp")) {
> +                       if (!argv[i].value) {
> +                               error(G_("no value supplied for option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
> +                               continue;
> +                       }
> +                       track_frame_size = atoi(argv[i].value);
> +                       if (argv[i].value[0] < '0' || argv[i].value[0] > '9' || track_frame_size < 0)
> +                               error(G_("invalid option argument '-fplugin-arg-%s-%s=%s'"), plugin_name, argv[i].key, argv[i].value);
> +                       continue;
> +               }
> +               if (!strcmp(argv[i].key, "initialize-locals")) {
> +                       if (argv[i].value) {
> +                               error(G_("invalid option argument '-fplugin-arg-%s-%s=%s'"), plugin_name, argv[i].key, argv[i].value);
> +                               continue;
> +                       }
> +                       init_locals = true;
> +                       continue;
> +               }
> +               error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
> +       }

Just noticed this: there is an undocumented "initialize-locals" plugin
argument that set an unused init_locals variables. (And it's
unused-ness matches the TODO at the top.)

Probably the unused arg/var should be dropped (or better yet:
implemented to do the initialization).

-Kees

-- 
Kees Cook
Pixel Security
