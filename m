MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170218235001.20276-1-colin.king@canonical.com>
References: <20170218235001.20276-1-colin.king@canonical.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Feb 2017 11:15:03 -0800
Message-ID: <CAGXu5j+xuXwOYKJ=S+9zxAZAGOxo2bFz9+CT21xLRjQHK6onRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: fix spelling mistake: "unkown" -> "unknown"
To: Colin King <colin.king@canonical.com>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 18, 2017 at 3:50 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> trivial fix to spelling mistake in error message

Thanks! I've already got this updated. I noticed the same thing a
couple weeks ago. :)

-Kees

>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  scripts/gcc-plugins/initify_plugin.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/gcc-plugins/initify_plugin.c b/scripts/gcc-plugins/initify_plugin.c
> index 56ed878..2ed998a 100644
> --- a/scripts/gcc-plugins/initify_plugin.c
> +++ b/scripts/gcc-plugins/initify_plugin.c
> @@ -1846,7 +1846,7 @@ __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gc
>                         continue;
>                 }
>
> -               error(G_("unkown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
> +               error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
>         }
>
>         register_callback(plugin_name, PLUGIN_INFO, NULL, &initify_plugin_info);
> --
> 2.10.2
>



-- 
Kees Cook
Pixel Security
