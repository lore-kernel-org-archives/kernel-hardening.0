Return-Path: <SRS0=5l0Y=AD=lists.openwall.com=kernel-hardening-return-19032-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E375C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 14:46:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 67FF62071A
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 14:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67FF62071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19032-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30525 invoked by uid 550); 22 Jun 2020 14:45:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30490 invoked from network); 22 Jun 2020 14:45:57 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+6eMmHPTrb0d3gg0bQJassvP7E5X7KeEpWp5glz92jw=;
        b=f4fKaSqZK1+oLhSxT2CJWVNg/ovumOPuNZ4ClwptdriWYrkLgRr7W2GSC8fMox2gRz
         nyHPHUVe8A7Uy0ieDT/kPbuizP41c3182CZi89PMdYCfETeiHETCiVMLPZ1Hqtscyc+0
         MX9/kvM2Tn+1vB1Hr2EY5/2vuzc1Yau89bhS+PHm42jSFl7+COxJjGGKtUYiDDIXJQ4f
         IqTNIwbl/G7MgL5v8NRwuOdJUqPrWWbnvkgP/PTfzibksHwyoFTYtPvnnzv4TpNQFMVc
         wLrolK7BaamAMr5Hs+9PqbaktUk1QpXdIz2l6iZPCFlwSvxzoRsRsGH1HYjMLiRoX1By
         9RhQ==
X-Gm-Message-State: AOAM532SRP2VVQVm485eXQ/CA6t9/9sXccHQgK/2UfF5qhOM8Ick4yXL
	/icVaoq222Ewk8pHV5GmjnYkDnNYsVKT6qwHVqE=
X-Google-Smtp-Source: ABdhPJz3XIhgbNdrEjLxuwZV8l3ADfdcwxIkEAbudMbN4QUSwurz6C7DjucnqYBFfKoN8iUAdhq9pCK6M2zUIPPYoVY=
X-Received: by 2002:aca:ab92:: with SMTP id u140mr12382604oie.68.1592837145739;
 Mon, 22 Jun 2020 07:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
 <20200615104332.901519-1-Jason@zx2c4.com> <CAHmME9oemScgo2mg8fzqtJCbKJfu-op0WvG5RcpBCS1hHNmpZw@mail.gmail.com>
In-Reply-To: <CAHmME9oemScgo2mg8fzqtJCbKJfu-op0WvG5RcpBCS1hHNmpZw@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 22 Jun 2020 16:45:33 +0200
Message-ID: <CAJZ5v0gPQ_5R0AQAN2TMb3m12N9egUst0+MDXTak_u0Tn13+Bw@mail.gmail.com>
Subject: Re: [PATCH] acpi: disallow loading configfs acpi tables when locked down
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, 
	LKML <linux-kernel@vger.kernel.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, Jun 17, 2020 at 12:20 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Rafael, Len,
>
> Looks like I should have CC'd you on this patch. This is probably
> something we should get into 5.8-rc2, so that it can then get put into
> stable kernels, as some people think this is security sensitive.
> Bigger picture is this:
>
> https://data.zx2c4.com/american-unsigned-language-2.gif
> https://data.zx2c4.com/american-unsigned-language-2-fedora-5.8.png

I was offline during the last week, sorry.

Applied as 5.8-rc material with some subject/changelog edits, thanks!
