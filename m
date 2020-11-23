Return-Path: <SRS0=TkE1=E5=lists.openwall.com=kernel-hardening-return-20454-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7FEC2D0E4
	for <kernel-hardening@archiver.kernel.org>; Mon, 23 Nov 2020 10:37:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F1A2C2075A
	for <kernel-hardening@archiver.kernel.org>; Mon, 23 Nov 2020 10:37:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TDVt/xqw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1A2C2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20454-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9952 invoked by uid 550); 23 Nov 2020 10:37:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29715 invoked from network); 23 Nov 2020 10:22:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KicNkypOIaNLZNofAMT0/dbRVfdiQb0EG7yDuWE5ulA=;
        b=TDVt/xqwo7FGjOiB50CURiRd4zX8Glpc/xzed4IR3D50NS0EqlijbKWHNsEmT9A92f
         opeYzaDlby6Pgpezpy0Z6eYOPQW6ipaIAyEAtip0SZR01YDtd+SICLsxoZ+9krn8s+et
         lULt1gHvEOthv2285g8UdKxZGn8PuitA3T+FAGLQ/qKxFihLT0OrTedRRYXRz8VblfZD
         a1sXohEAJiNhEPF+raDuSX6Ta4nQGnI6siEeVnxshXZXFTiwE+mIarl4EbBFaSYp4ZqT
         zvmMqJJexFfo+5+oFHJeofxyxcmA2hqWZAvCeahk9touSv1o0xYBPyhqFNpgNP0LgZcR
         CU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KicNkypOIaNLZNofAMT0/dbRVfdiQb0EG7yDuWE5ulA=;
        b=ei2MqkpXIBOQabrVQ/bdkq9lRAIhiAakkpxX+YLVLMpmhm0l/TkaSqXNuTUw/TTZkG
         7FZi6PqbIJI10d3wIZjTAp4sMk67rs60frbqIpf1Lq3L4pmV0SwbrDJ0Sq5zWOYemYCO
         zADM0ejPDORHNmflbeIOm6PYoQvuOCK8KvhPDfJfsmDivXCEM15j36Vf66fMazFFhf/w
         SQFSKbaymjJpbPcVM56gkVDJqIJ+XPAnAwH1DRj8d+NJRB7Y36IOFUtWja+vCfSP00vO
         xaP2ymXmnoPqDI6NfFwxOo9IfAlL2s7idtJQRxElm+nyWDPZTF5zVLrKO7eUyFWDrKuF
         puBg==
X-Gm-Message-State: AOAM5321df/zNslDgFas5J0mxCKTC8nqUUc2zb6G9Qop23G3RZfk9viF
	dRULz7hF9iPM8P2uLZ98wqPZjA==
X-Google-Smtp-Source: ABdhPJxFSYMYi0puK0drxRNruUpOKNZHKEgE3EPEQ608H69x9iUkj+1IRAw3SWeiVlPLVEVUtEhq+A==
X-Received: by 2002:a17:906:8058:: with SMTP id x24mr44772875ejw.272.1606126911958;
        Mon, 23 Nov 2020 02:21:51 -0800 (PST)
Date: Mon, 23 Nov 2020 10:21:49 +0000
From: David Brazdil <dbrazdil@google.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 15/17] KVM: arm64: disable LTO for the nVHE directory
Message-ID: <20201123102149.ogl642tw234qod62@google.com>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-16-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220731.925424-16-samitolvanen@google.com>

Hey Sami,

On Wed, Nov 18, 2020 at 02:07:29PM -0800, Sami Tolvanen wrote:
> We use objcopy to manipulate ELF binaries for the nVHE code,
> which fails with LTO as the compiler produces LLVM bitcode
> instead. Disable LTO for this code to allow objcopy to be used.

We now partially link the nVHE code (generating machine code) before objcopy,
so I think you should be able to drop this patch now. Tried building your
branch without it, ran a couple of unit tests and all seems fine.

David
