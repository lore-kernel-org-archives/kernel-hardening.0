Return-Path: <SRS0=B3Nn=H2=lists.openwall.com=kernel-hardening-return-20828-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF25C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 22:43:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CECF764EDD
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 22:43:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CECF764EDD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20828-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26422 invoked by uid 550); 24 Feb 2021 22:43:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26396 invoked from network); 24 Feb 2021 22:43:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4qD0bh+6rEBJ6s6+qgDoBSjSKGiQ2q5y7JANudls5vI=;
        b=I1JHwIT+U9OO58Pc38ZuzAs2QzAh1xLUIAgX6huh6oz167TxF14RSoBid8UxG9B4qr
         OLWIXx0MZfnvjexW2V6qo9YvswdcbLQ3692oJSi14V+eV8cqWF7ZJ9sHpr6MOsiQR/pn
         6y+MrmnuWJSbFvzWiB+gcgOHY4RvFpNasRt18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4qD0bh+6rEBJ6s6+qgDoBSjSKGiQ2q5y7JANudls5vI=;
        b=uUBWJLNy2qaBM2mDWvYC1HoLx7zbKhVCKPDGGaOfCt85R0sG5fLvqSHZw4NySB6uln
         VHJqCZdcLueTqQXCeR8ek2MHIt3QPw/UiMvg80igX9+TeAHcEBdjHS75gOVtgWs78OsY
         0XFTqp3BHPIE/SZQMeFSLPq4peYHTubZ0MOo6+Xf+mz8lLgV+UUcipJUEzfRyBo4R0Dv
         eS+LfV10B2M/vOuR/YjyM2tsHa80cPOcK9lh1xr1SnZMii1xBh7BxEStR0N86WIyuUXa
         oIQkQPwo7kCy588lv2814E1CyhoSR9WwrRbgJe4dWV5ZNWT45yPJLQkPn97j1mu0aeSw
         pBJQ==
X-Gm-Message-State: AOAM530O5llTqW2EL6UQyPCu4eSgYo81MeLt9Sc4q8UFhgGhVl3cnsr/
	ILf0pgcNE6DQ6RJWSu8P94IVNQ==
X-Google-Smtp-Source: ABdhPJy+FDtnD+N/ZjqgPPbWw42HtyErBlOSrKNol4tmTskqrDwuTPUww2A8PcDziLPJAW0AfGil9w==
X-Received: by 2002:a17:902:9f94:b029:e3:287f:9a3a with SMTP id g20-20020a1709029f94b02900e3287f9a3amr296408plq.46.1614206571524;
        Wed, 24 Feb 2021 14:42:51 -0800 (PST)
Date: Wed, 24 Feb 2021 14:42:49 -0800
From: Kees Cook <keescook@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-parisc@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH v9 01/16] tracing: move function tracer options to
 Kconfig (causing parisc build failures)
Message-ID: <202102241442.C456318BC0@keescook>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-2-samitolvanen@google.com>
 <20210224201723.GA69309@roeck-us.net>
 <202102241238.93BC4DCF@keescook>
 <20210224222807.GA74404@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224222807.GA74404@roeck-us.net>

On Wed, Feb 24, 2021 at 02:28:07PM -0800, Guenter Roeck wrote:
> On Wed, Feb 24, 2021 at 12:38:54PM -0800, Kees Cook wrote:
> > On Wed, Feb 24, 2021 at 12:17:23PM -0800, Guenter Roeck wrote:
> > > On Fri, Dec 11, 2020 at 10:46:18AM -0800, Sami Tolvanen wrote:
> > > > Move function tracer options to Kconfig to make it easier to add
> > > > new methods for generating __mcount_loc, and to make the options
> > > > available also when building kernel modules.
> > > > 
> > > > Note that FTRACE_MCOUNT_USE_* options are updated on rebuild and
> > > > therefore, work even if the .config was generated in a different
> > > > environment.
> > > > 
> > > > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > > > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > 
> > > With this patch in place, parisc:allmodconfig no longer builds.
> > > 
> > > Error log:
> > > Arch parisc is not supported with CONFIG_FTRACE_MCOUNT_RECORD at scripts/recordmcount.pl line 405.
> > > make[2]: *** [scripts/mod/empty.o] Error 2
> > > 
> > > Due to this problem, CONFIG_FTRACE_MCOUNT_RECORD can no longer be
> > > enabled in parisc builds. Since that is auto-selected by DYNAMIC_FTRACE,
> > > DYNAMIC_FTRACE can no longer be enabled, and with it everything that
> > > depends on it.
> > 
> > Ew. Any idea why this didn't show up while it was in linux-next?
> > 
> 
> It did, I just wasn't able to bisect it there.

Ah-ha! Okay, thanks. Sorry it's been broken for so long! I've added
parisc to my local cross builder now.

-- 
Kees Cook
