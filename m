MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <eeba7607-f920-2c34-1906-6517a00cd2a5@redhat.com>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org> <eeba7607-f920-2c34-1906-6517a00cd2a5@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 15 Apr 2017 11:50:48 -0700
Message-ID: <CAGXu5jJyoDiOeih5QMKYTSL+1Lg1yXFEJ38MLYrAnGMy5wRqQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 00/18] Introduce struct layout
 randomization plugin
To: Laura Abbott <labbott@redhat.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 13, 2017 at 4:39 PM, Laura Abbott <labbott@redhat.com> wrote:
> I gave this a quick spin on my aarch64 Rawhide machine. I needed to
> change the following to work with gcc7
>
> diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
> index a2d7e933c33f..8dd5134f161a 100644
> --- a/scripts/gcc-plugins/randomize_layout_plugin.c
> +++ b/scripts/gcc-plugins/randomize_layout_plugin.c
> @@ -529,8 +529,8 @@ static void randomize_layout_finish_decl(void *event_data, void *data)
>
>         DECL_SIZE(decl) = 0;
>         DECL_SIZE_UNIT(decl) = 0;
> -       DECL_ALIGN(decl) = 0;
> -       DECL_MODE (decl) = VOIDmode;
> +       SET_DECL_ALIGN(decl, 0);
> +       SET_DECL_MODE(decl, VOIDmode);
>         SET_DECL_RTL(decl, 0);
>         update_decl_size(decl);
>         layout_decl(decl, 0);

Very cool, thanks! I'll adjust the common header file to provide these
macros for gcc pre-7 builds and update the series.

> It boots but dies with a bunch of kernel faults somewhere after reaching
> userspace. I'll pick up the debugging next week.

I've been thinking about splitting up the structure marking patch into
per-structure markings to make failure bisection easier. I assume
there's a specific structure that is misbehaving on aarch64 (my first
guess is always task_struct).

-Kees

-- 
Kees Cook
Pixel Security
