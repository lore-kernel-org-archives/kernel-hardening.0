Reply-To: kernel-hardening@lists.openwall.com
References: <20160517022728.GA2821@www.outflux.net>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <573B399F.40602@infradead.org>
Date: Tue, 17 May 2016 08:32:47 -0700
MIME-Version: 1.0
In-Reply-To: <20160517022728.GA2821@www.outflux.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] doc: self-protection: provide initial details
To: Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 05/16/16 19:27, Kees Cook wrote:
> This document attempts to codify the intent around kernel self-protection
> along with discussion of both existing and desired technologies, with
> attention given to the rationale behind them, and the expectations of
> their usage.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/security/self-protection.txt | 261 +++++++++++++++++++++++++++++
>  1 file changed, 261 insertions(+)
>  create mode 100644 Documentation/security/self-protection.txt
> 
> diff --git a/Documentation/security/self-protection.txt b/Documentation/security/self-protection.txt
> new file mode 100644
> index 000000000000..33ad7183a074
> --- /dev/null
> +++ b/Documentation/security/self-protection.txt
> @@ -0,0 +1,261 @@

[snip]

> +
> +The goals for successful self-protection systems would be to that they

                                                    would be that they

> +are effective, on by default, require no opt-in by developers, have no
> +performance impact, do not impede kernel debugging, and have tests. It
> +is uncommon that all these goals can be met, but it is worth explicitly
> +mentioning them, since these aspects need to be explored, dealt with,
> +and/or accepted.
> +
> +
> +
> +What remains are variables that are updated rarely (e.g. GDT). These
> +will need another infrastructure (similar to the temporary exceptions
> +made to kernel code mentioned above) that allow them to spend the rest
> +of their lifetime read-only. (For example, when being updated, only the
> +CPU thread performing the update would be given uninterruptable write

                                                   uninterruptible

> +access to the memory.)

(add to spelling.txt ?)

> +
> +

> +
> +
> +To protect against even privileged users, systems may need to either
> +disable module loading entirely (e.g. monolithic kernel builds or
> +modules_disabled sysctl), or provide signed modules (e.g.
> +CONFIG_MODULE_SIG_FORCE, or dm-crypt with LoadPin), to keep from having
> +oot load arbitrary kernel code via the module loader interface.

spell out 'oot'

> +
> +
> +## Preventing Leaks
> +
> +Since the location of sensitive structures are the primary target for

                                              is
or
              locations                       are

> +attacks, it is important to defend against leaks of both kernel memory
> +addresses and kernel memory contents (since they may contain kernel
> +addresses or other sensitive things like canary values).
> +


Nice job.
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
~Randy
