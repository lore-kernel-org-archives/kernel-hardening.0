Return-Path: <SRS0=hvYB=GK=lists.openwall.com=kernel-hardening-return-20612-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FA3C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Jan 2021 08:40:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2CD0B2311E
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Jan 2021 08:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CD0B2311E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20612-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21624 invoked by uid 550); 7 Jan 2021 08:39:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21604 invoked from network); 7 Jan 2021 08:39:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610008778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b/gjdBCSmSXKkH6UZrD67rlhCNa+Qh7NKibomcVRCXg=;
	b=GFScFeuiP0gYrwf89SQxpVvkN7S/XrYZeWaNuctCUhlzZJ+/mXobrRkvBx8ZLGeJ2LjUE1
	o8NCxu2SxB0siULJjJcvRpLvPqKmFDekYvvR/aQ7TGghoMG8YJwSnRG3gmgmKXTU4/xWiP
	SHXjJp5FcjJdGbwU/KVjm0uk6kOUJ0Y=
X-MC-Unique: pG8_4YEoNCOpQf0p1tf4Qg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b/gjdBCSmSXKkH6UZrD67rlhCNa+Qh7NKibomcVRCXg=;
        b=ql9gnK3sdclwP6ma8mKkrDfm764y9GMmvGPI05CGVdW2FyMGh4gd7Yisb4Bv1WPtY6
         5PAKgj5p4X069DWCxPqlJx0hDW4Vx6TW6mpAgmxQWI2E0tg0tMFO6nPh0XnZFBFdY2bD
         LWoVBgNKa+68oYqNDJN4mUtR3lYjwzwWZc5RY7HdY4OIy+IDICLQ1QvP8f/1blIvKEpZ
         RhouX/8uZxoFCGK6lEZVuqErDByfwcIeJ4H+DcXEFZMVDZDEPsWd+0SV7B+H/lXtqHdT
         xtf7FwnebdeXT5eMXMIGXUztsMpNx2DD9760dThQA1JD78lPWH0/RzsdsQ2tblGIOWD8
         BOQw==
X-Gm-Message-State: AOAM5329Hbceg1QtC/F4vIP4/3cC5usPQpnbuOcrDlLu/KpPhtjrR9Cz
	aj/3XYPOuwegjZvu+OLi17rHh1J7Xw32rqbdrwj2z4wCMPVt/ezUcOTz1XHxbO0rUIBOv66m81l
	6YUr1li9v7H7lOzKfi78dZJUCFi5ppRte/w==
X-Received: by 2002:a5d:554e:: with SMTP id g14mr7962489wrw.264.1610008775833;
        Thu, 07 Jan 2021 00:39:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7UTbth5UPeghaUf4Y/9GWuz3fDS27vvZLBin1zacQw3Tp5n2al3IsoTK+x69AxDSZwlgDNg==
X-Received: by 2002:a5d:554e:: with SMTP id g14mr7962459wrw.264.1610008775620;
        Thu, 07 Jan 2021 00:39:35 -0800 (PST)
Date: Thu, 7 Jan 2021 09:39:32 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Daurnimator <quae@daurnimator.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	io-uring <io-uring@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Stefan Hajnoczi <stefanha@redhat.com>, Jann Horn <jannh@google.com>,
	Jeff Moyer <jmoyer@redhat.com>, Aleksa Sarai <asarai@suse.de>,
	Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <20210107083932.ho6vo5g5hmdohwqt@steredhat>
References: <20200827145831.95189-1-sgarzare@redhat.com>
 <20200827145831.95189-3-sgarzare@redhat.com>
 <CAEnbY+fS8FXVeouOxN3uohTvo7fBi5r7TQCGBZUmG3MGJhBrYg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEnbY+fS8FXVeouOxN3uohTvo7fBi5r7TQCGBZUmG3MGJhBrYg@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Mon, Jan 04, 2021 at 01:26:41AM +1100, Daurnimator wrote:
>On Fri, 28 Aug 2020 at 00:59, Stefano Garzarella <sgarzare@redhat.com> wrote:
>> +               __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
>
>Can you confirm that this intentionally limited the future range of
>IORING_REGISTER opcodes to 0-255?
>

It was based on io_uring_probe, so we used u8 for opcodes, but we have 
room to extend it in the future.

So, for now, this allow to register restrictions up to 255 
IORING_REGISTER opcode.

