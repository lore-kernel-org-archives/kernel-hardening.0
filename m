Return-Path: <SRS0=doK6=XZ=lists.openwall.com=kernel-hardening-return-16972-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E679C32792
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:46:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4FDB92168B
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AgPEOfJf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FDB92168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16972-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20378 invoked by uid 550); 30 Sep 2019 22:46:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20346 invoked from network); 30 Sep 2019 22:46:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aafXsvMu5ilktN6hKbWxhnmLwH3fiFerBC1aKpy4QOw=;
        b=AgPEOfJfBKW9CoitsjOGYwPSfDY991XhT124UQZqp2ZzzR9fe51E8PU9UFf5hfeoii
         IZHyFPGIJzOS2fBa1F+wtNQpco0eeyqrJ3yE7qJPLVgSgz4Cuj1SbsojGIxc2iNYeuIK
         20tFtnQVnqcdnVBaB2TDyBxva7g58FFJBo2PY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aafXsvMu5ilktN6hKbWxhnmLwH3fiFerBC1aKpy4QOw=;
        b=os627Ux7RH8av/cOwD5FFzMX9BAWPFWc2CeCGoNpI5bQQ3wBQFETTL2rADVL4GXDNs
         kbczULrcWmTTjRg3kJTfhe0uat3bZk/DfrywZjtnq83MVRr/hB8xOGU7icpOOTHEIq43
         2nL8XOyckk314RCwyjdysK+Ep5UuQYUvDEMQrqPoMPpLFCR2YFo8NRTdrW16FnEyWzcu
         RgYR/AAtww19aCMteJFKiDxM7ov6tu2+58ZeQvfqc05hfczrFEeympqfNfqIUXcBIRwT
         xrHMA6r7aBkHffgclhh12g3XBp0DpO52UIDpCIcmWUmDZYVxezsyB5B6g7Lm/vrkfnwz
         z7zQ==
X-Gm-Message-State: APjAAAW0h3ed5UJS2l2q3CN0sulMjPO1qQ0Ig7TBKMtZEYWC1BtSIKFh
	C8E6HVMI+gqzzbIxwI96WXpT2A==
X-Google-Smtp-Source: APXvYqz/3Z/HuLkMONti9m813UXwDFopAs2luq9YUvt4buzgsrZaUrUjrlgz86VlWqaU8NQ+BXe81Q==
X-Received: by 2002:a62:e106:: with SMTP id q6mr23624595pfh.14.1569883590876;
        Mon, 30 Sep 2019 15:46:30 -0700 (PDT)
Date: Mon, 30 Sep 2019 15:46:29 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 11/16] treewide: Globally replace
 tasklet_init() by tasklet_setup()
Message-ID: <201909301545.913F7805AB@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-12-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929163028.9665-12-romain.perier@gmail.com>

On Sun, Sep 29, 2019 at 06:30:23PM +0200, Romain Perier wrote:
> This converts all remaining cases of the old tasklet_init() API into
> tasklet_setup(), where the callback argument is the structure already
> holding the struct tasklet_struct. These should have no behavioral changes,
> since they just change which pointer is passed into the callback with
> the same available pointers after conversion. Moreover, all callbacks
> that were not passing a pointer of structure holding the struct
> tasklet_struct has already been converted.

Was this done mechanically with Coccinelle or manually? (If done with
Coccinelle, please include the script in the commit log.) To land a
treewide change like this usually you'll need to separate the mechanical
from the manual as Linus likes to run those changes himself sometimes.

-- 
Kees Cook
