Return-Path: <SRS0=TF13=5L=lists.openwall.com=kernel-hardening-return-18231-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFD1C43331
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 02:06:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B9D6720737
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 02:06:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jpWMLrec"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9D6720737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18231-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19975 invoked by uid 550); 26 Mar 2020 02:06:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19943 invoked from network); 26 Mar 2020 02:06:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uYQlUOBpCvYvOWq81vYWj8BjX92aUfuzlVBqw9QmtNs=;
        b=jpWMLrecHH6IEFQVM8Dz7CE3drKGde9Flq7g8WENLKiy05FJ5Ox+VdyQQ7/eor7Ho8
         5O8yPvQ5luFXcgN+uNHZe9jlbmNbgXaSP8WwBxByjm7OBtPMMW2Pruno0EQcHVNqmPxp
         CNl9i/InueSAqWKYyo+Oy1EumDxQdm1VuEdis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uYQlUOBpCvYvOWq81vYWj8BjX92aUfuzlVBqw9QmtNs=;
        b=KT6VzmNizE67ZfJCgwqDfB7LdpRz70/YKC7bo6eUwC0TMR8dtAqV39W2/eUyzMewPk
         Oj5suCueCbiDRY47cB156r66BKJI+xEIfbbuZAkjlORx6DanxcY+6PVcZiTTOySa0LH/
         g91REVrGgOApjM+f0HxcEoY08kUW2W/DpPdlWwt/4MttlFUOGZ1AGCyg+Uj+mY6qX33g
         hFsUFcPgcnBq5YS0I4s6tuvZ33u/p3qj+wG/Q8nsThwUFeAm9eQ5yeUbNsZonUFmHXKg
         PQkll43aO67LTQOuJSuNIc34Ws64QThgegVt+vVAl+JSdWlDCLnMKtqTWMUNPsHJUUIO
         gebg==
X-Gm-Message-State: ANhLgQ15i9lSI++xaueloavrei/3cCwBnSMrAHDU2mxdeAzfHu+sPZHq
	xQhzi8c4H3qOQZzWhhGeAs+iTA==
X-Google-Smtp-Source: ADFU+vtyHMwnZ0WOXPD0etbF8ofWdyYnDBq3cVX0KeXPYvpmhLbSGzBIQYI/Sqa44z3LYzft4soCUw==
X-Received: by 2002:a63:2989:: with SMTP id p131mr6064326pgp.281.1585188392313;
        Wed, 25 Mar 2020 19:06:32 -0700 (PDT)
Date: Wed, 25 Mar 2020 19:06:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Emese Revfy <re.emese@gmail.com>,
	Michal Marek <michal.lkml@markovi.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kbuild: add -Wall to KBUILD_HOSTCXXFLAGS
Message-ID: <202003251906.973AD868@keescook>
References: <20200325031433.28223-1-masahiroy@kernel.org>
 <20200325031433.28223-2-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325031433.28223-2-masahiroy@kernel.org>

On Wed, Mar 25, 2020 at 12:14:32PM +0900, Masahiro Yamada wrote:
> Add -Wall to catch more warnings for C++ host programs.
> 
> When I submitted the previous version, the 0-day bot reported
> -Wc++11-compat warnings for old GCC:
> 
>   HOSTCXX -fPIC scripts/gcc-plugins/latent_entropy_plugin.o
> In file included from /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/tm.h:28:0,
>                  from scripts/gcc-plugins/gcc-common.h:15,
>                  from scripts/gcc-plugins/latent_entropy_plugin.c:78:
> /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/config/elfos.h:102:21: warning: C++11 requires a space between string literal and macro [-Wc++11-compat]
>     fprintf ((FILE), "%s"HOST_WIDE_INT_PRINT_UNSIGNED"\n",\
>                      ^
> /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/config/elfos.h:170:24: warning: C++11 requires a space between string literal and macro [-Wc++11-compat]
>        fprintf ((FILE), ","HOST_WIDE_INT_PRINT_UNSIGNED",%u\n",  \
>                         ^
> In file included from /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/tm.h:42:0,
>                  from scripts/gcc-plugins/gcc-common.h:15,
>                  from scripts/gcc-plugins/latent_entropy_plugin.c:78:
> /usr/lib/gcc/x86_64-linux-gnu/4.8/plugin/include/defaults.h:126:24: warning: C++11 requires a space between string literal and macro [-Wc++11-compat]
>        fprintf ((FILE), ","HOST_WIDE_INT_PRINT_UNSIGNED",%u\n",  \
>                         ^
> 
> The source of the warnings is in the plugin headers, so we have no
> control of it. I just suppressed them by adding -Wno-c++11-compat to
> scripts/gcc-plugins/Makefile.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> 
>  Makefile                     | 2 +-
>  scripts/gcc-plugins/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 3b57ccab367b..593d8f1bbe90 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -400,7 +400,7 @@ HOSTCXX      = g++
>  KBUILD_HOSTCFLAGS   := -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 \
>  		-fomit-frame-pointer -std=gnu89 $(HOST_LFS_CFLAGS) \
>  		$(HOSTCFLAGS)
> -KBUILD_HOSTCXXFLAGS := -O2 $(HOST_LFS_CFLAGS) $(HOSTCXXFLAGS)
> +KBUILD_HOSTCXXFLAGS := -Wall -O2 $(HOST_LFS_CFLAGS) $(HOSTCXXFLAGS)
>  KBUILD_HOSTLDFLAGS  := $(HOST_LFS_LDFLAGS) $(HOSTLDFLAGS)
>  KBUILD_HOSTLDLIBS   := $(HOST_LFS_LIBS) $(HOSTLDLIBS)
>  
> diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
> index f2ee8bd7abc6..efff00959a9c 100644
> --- a/scripts/gcc-plugins/Makefile
> +++ b/scripts/gcc-plugins/Makefile
> @@ -10,7 +10,7 @@ else
>    HOSTLIBS := hostcxxlibs
>    HOST_EXTRACXXFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu++98 -fno-rtti
>    HOST_EXTRACXXFLAGS += -fno-exceptions -fasynchronous-unwind-tables -ggdb
> -  HOST_EXTRACXXFLAGS += -Wno-narrowing -Wno-unused-variable
> +  HOST_EXTRACXXFLAGS += -Wno-narrowing -Wno-unused-variable -Wno-c++11-compat
>    export HOST_EXTRACXXFLAGS
>  endif
>  
> -- 
> 2.17.1
> 

-- 
Kees Cook
