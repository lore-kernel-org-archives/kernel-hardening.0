Return-Path: <SRS0=NHQe=IO=lists.openwall.com=kernel-hardening-return-20950-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77957C433DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 18:49:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 931096511A
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 18:49:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 931096511A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20950-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9443 invoked by uid 550); 16 Mar 2021 18:49:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9419 invoked from network); 16 Mar 2021 18:49:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ywai4YPe6URsofe8kbvRJ5BLerohwMgOUz2A+yTu1V8=;
        b=Gi/mZifZtaRGM1hAEWLLYtHoNGjeBYezFLY4Ub3n4u88qoaWqF2dg8531Bz2gbABn6
         FO4WtNeX0KhGduNg1GnpbY9Y/CIeAnzjNt9lLhqJ3bQiOEJ4BtAToC4VblibmRyuvANn
         uwgAnFSNL24Cp92te+97NTCIADTkE1HxM61l4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ywai4YPe6URsofe8kbvRJ5BLerohwMgOUz2A+yTu1V8=;
        b=Q/pGfqVQIzOgia7hsDYIFbzfud9ZN83kOU8xb5EtyhJZhyhjnVU0xTVbsgKN4ZQPMi
         ZShZPg4Ke0jTErdtimFaFPjtA62i7GXskc8EJ3/fJdkMSOlkgB/pYrNwMpDAMkVsJmT1
         zqiEPMX8Ie5OQ9j7OMQ6+zVTqfcGaLGPFOce1GjpSOhwlbIQDQ+rUc2CWW4E42Cr4RjL
         b6OCXFiBGv6inI8nHc4u1g7pGwbzckqtWjquhAsEj1BCHCFhKOagB+G761ks76KDV1F+
         4jst2DG/5lEhBlpCBgfgiR20FH25qxcNiEPlBt2eaIPZ740nEkiUpzxbUu8xHZkfOv38
         42dw==
X-Gm-Message-State: AOAM531SK9NxqRNc/u+ZgndVQjSYhd+JN04Ba8XpNEOyplDdVUFm05xg
	17gyq5qX8IucroTDIeHPD2Hl4w==
X-Google-Smtp-Source: ABdhPJz3uNdO8WaSSFDiiPWSz3MOZAP5SYHuuEd9I+bSp0sGeAPb9gjvi+a+I3tMUX5HzOo1dk+55Q==
X-Received: by 2002:a17:902:7612:b029:e5:f0dd:8667 with SMTP id k18-20020a1709027612b02900e5f0dd8667mr739777pll.59.1615920562658;
        Tue, 16 Mar 2021 11:49:22 -0700 (PDT)
Date: Tue, 16 Mar 2021 11:49:20 -0700
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	io-uring <io-uring@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Linux-MM <linux-mm@kvack.org>, Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 3/8] Use atomic_t for ucounts reference counting
Message-ID: <202103161146.E118DE5@keescook>
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
 <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
 <202103151426.ED27141@keescook>
 <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>

On Mon, Mar 15, 2021 at 03:19:17PM -0700, Linus Torvalds wrote:
> It just saturates, and doesn't have the "don't do this" case, which
> the ucounts case *DOES* have.

Right -- I saw that when digging through the thread. I'm honestly
curious, though, why did the 0-day bot find a boot crash? (I can't
imagine ucounts wrapped in 0.4 seconds.) So it looked like an
increment-from-zero case, which seems like it would be a bug?

> I know you are attached to refcounts, but really: they are not only
> more expensive, THEY LITERALLY DO THE WRONG THING.

Heh, right -- I'm not arguing that refcount_t MUST be used, I just didn't
see the code path that made them unsuitable: hitting INT_MAX - 128 seems
very hard to do. Anyway, I'll go study it more to try to understand what
I'm missing.

-- 
Kees Cook
