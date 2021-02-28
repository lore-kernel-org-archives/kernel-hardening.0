Return-Path: <SRS0=dR9r=H6=lists.openwall.com=kernel-hardening-return-20861-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF64C433DB
	for <kernel-hardening@archiver.kernel.org>; Sun, 28 Feb 2021 11:51:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1E31764E66
	for <kernel-hardening@archiver.kernel.org>; Sun, 28 Feb 2021 11:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E31764E66
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20861-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23669 invoked by uid 550); 28 Feb 2021 11:51:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23634 invoked from network); 28 Feb 2021 11:50:59 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: lake55_4500ff4276ab
X-Filterd-Recvd-Size: 2254
Message-ID: <1bf09d848148311a952870113401077dfc956bbd.camel@perches.com>
Subject: Re: [PATCH 11/20] hwmon: Manual replacement of the deprecated
 strlcpy() with return values
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>, Romain Perier
 <romain.perier@gmail.com>,  Kees Cook <keescook@chromium.org>,
 kernel-hardening@lists.openwall.com
Cc: linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 28 Feb 2021 03:50:44 -0800
In-Reply-To: <3b8dd556-8c09-9686-dec6-9d523a9762a8@roeck-us.net>
References: <20210222151231.22572-1-romain.perier@gmail.com>
	 <20210222151231.22572-12-romain.perier@gmail.com>
	 <3b8dd556-8c09-9686-dec6-9d523a9762a8@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2021-02-22 at 07:46 -0800, Guenter Roeck wrote:
> On 2/22/21 7:12 AM, Romain Perier wrote:
> > The strlcpy() reads the entire source buffer first, it is dangerous if
> > the source buffer lenght is unbounded or possibility non NULL-terminated.
> 
> length
> 
> > It can lead to linear read overflows, crashes, etc...
> > 
> Not here. This description is misleading.
> 
> > As recommended in the deprecated interfaces [1], it should be replaced
> > by strscpy.
> > 
> > This commit replaces all calls to strlcpy that handle the return values
> > by the corresponding strscpy calls with new handling of the return
> > values (as it is quite different between the two functions).
> > 
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> > 
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> 
> This patch just adds pain to injury, as the source 'buffers' are all fixed
> strings and their length will never exceed the maximum buffer length.
> I really don't see the point of using strscpy() in this situation.

Might as well just use strcpy (I'd still prefer stracpy)

https://lore.kernel.org/lkml/24bb53c57767c1c2a8f266c305a670f7@sk2.org/T/


