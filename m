Message-ID: <1520575267.11634.25.camel@perches.com>
Subject: Re: [PATCH 4/4] video: Remove stack VLA usage
From: Joe Perches <joe@perches.com>
Date: Thu, 08 Mar 2018 22:01:07 -0800
In-Reply-To: <1520574625-4225-1-git-send-email-me@tobin.cc>
References: <1520574625-4225-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: "Tobin C. Harding" <me@tobin.cc>, Florian Tobias Schandinat <FlorianSchandinat@gmx.de>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2018-03-09 at 16:50 +1100, Tobin C. Harding wrote:
> The kernel would like to have all stack VLA usage removed[1].  The
> arrays are fixed here (declared with a const variable) but they appear
> like VLAs to the compiler.  We can use a pre-processor define to fix the
> warning.  
[]
> diff --git a/drivers/video/fbdev/via/via_aux_sii164.c b/drivers/video/fbdev/via/via_aux_sii164.c
[]
> @@ -27,6 +27,9 @@
>  
>  static const char *name = "SiI 164 PanelLink Transmitter";
>  
> +/* check vendor id and device id */
> +const u8 id[] = {0x01, 0x00, 0x06, 0x00};

It seems id is now global in multiple places.
Perhaps these should be static.

> diff --git a/drivers/video/fbdev/via/via_aux_vt1631.c b/drivers/video/fbdev/via/via_aux_vt1631.c
[]
> @@ -27,16 +27,19 @@
>  
>  static const char *name = "VT1631 LVDS Transmitter";
>  
> +/* check vendor id and device id */
> +const u8 id[] = {0x06, 0x11, 0x91, 0x31}, len = ARRAY_SIZE(id);

etc...
