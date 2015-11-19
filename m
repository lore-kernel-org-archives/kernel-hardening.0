Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <564E0590.2050600@redhat.com>
References: <bug-61313-391-meg9VHEJca@http.gcc.gnu.org/bugzilla/>
	<564E0590.2050600@redhat.com>
Date: Thu, 19 Nov 2015 10:08:03 -0800
Message-ID: <CAGXu5j+wHu51wztaLnBPgcfGKjgfhYQmxUQYtg9hG0oHv8r6tw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Fwd: [Bug lto/61313] configure incorrectly
 strips $target_alias from PLUGIN_LD_SUFFIX
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 19, 2015 at 9:23 AM, Jeff Law <law@redhat.com> wrote:
>
> And 24hrs after shunting the bug to the right guy, it's fixed :-)

Fantastic! Thanks very much for your help. :)

-Kees

>
>
> -------- Forwarded Message --------
> Subject: [Bug lto/61313] configure incorrectly strips $target_alias from
> PLUGIN_LD_SUFFIX
> Date: Thu, 19 Nov 2015 13:34:45 +0000
> From: ebotcazou at gcc dot gnu.org <gcc-bugzilla@gcc.gnu.org>
> To: law@redhat.com
>
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61313
>
> Eric Botcazou <ebotcazou at gcc dot gnu.org> changed:
>
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>              Status|ASSIGNED                    |RESOLVED
>          Resolution|---                         |FIXED
>    Target Milestone|---                         |4.9.4
>
> --- Comment #7 from Eric Botcazou <ebotcazou at gcc dot gnu.org> ---
> Fixed everywhere.
>
> --
> You are receiving this mail because:
> You are on the CC list for the bug.
>



-- 
Kees Cook
Chrome OS Security
