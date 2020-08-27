Return-Path: <SRS0=VTvH=CF=lists.openwall.com=kernel-hardening-return-19679-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD0CC433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 07:11:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1BDE720786
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 07:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ExLrN3li"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BDE720786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19679-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21795 invoked by uid 550); 27 Aug 2020 07:11:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21769 invoked from network); 27 Aug 2020 07:11:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598512296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wA1E5VINX4qFtBzgdOzHpby4Hxj21VGI22LvPkpMV1U=;
	b=ExLrN3liKg6jlt6zP8kb9DZoU+h5c+hMO9VnhqMRQbNR0fg86o84SsIH2jJTTc5rQbA40p
	8Fp7QA/4maReYsT1fQFAhwqndPWeV7zWD8x5+q64ae2sC6cEF8gQXML00sBtW84c3/F1QL
	MEI5Bf2EuPwFS/iBpYoMjDRiS5fjZCA=
X-MC-Unique: gRbqGRMBPNGFNM1LmyS_oA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wA1E5VINX4qFtBzgdOzHpby4Hxj21VGI22LvPkpMV1U=;
        b=gHQMw71RWgs/pIUAm15hXtf9aN8nCUJE5GETuUGWRUs+DLUjeUxgipEeYg5CnGobvh
         Pv2gHW43/E4C2FfbwhmGVFlOG4ksAKWXV+xGAPr0B62nNjaq9HfWpbo7a8uq9JLwB/1b
         4kvq5zKmsLVdw4K0VBQIfISMaSS6HMs1JQPOwbfGqF9+ccXci6OSua8XK8+PRw74eAsG
         o5hgb/MU0kFGsrHB3bjFSOLHLlktL/pSIQeI++t9JWgZUWi1gUjEUwOdgGsUBxjdHm24
         ReAcNRL9c+94zUvksUqONpbUqV5+ANQGvPylaTRlyHXzKFa8wtJMEu9Yjd+aJPYilq7F
         4iRw==
X-Gm-Message-State: AOAM532ToLbFqxJ8w/IbDYMKvXTuveun4CJLuWlnz2nzPCRZOr92BOpw
	XZFlqhHifoRPdjynOnCP54oaH2tGcPYG6LjFF3aviyd7HbjUImL7UJChAayYFkxKnNwQbmmyJlt
	A73frKq1hxDirDj/HFL3vgNGNvSuunqj4yw==
X-Received: by 2002:a1c:e1d6:: with SMTP id y205mr5699017wmg.92.1598512292923;
        Thu, 27 Aug 2020 00:11:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQLLfupwT3htk3SZsVuWhYX6+i7LaFRQaqAJ1Z0qPYkQk0csrl0zkKVvfPCI25zfzRfGsBQw==
X-Received: by 2002:a1c:e1d6:: with SMTP id y205mr5698987wmg.92.1598512292689;
        Thu, 27 Aug 2020 00:11:32 -0700 (PDT)
Date: Thu, 27 Aug 2020 09:11:27 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>, Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Sargun Dhillon <sargun@sargun.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Aleksa Sarai <asarai@suse.de>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
Message-ID: <20200827071127.iqq4gt3d5bpsq4xu@steredhat.lan>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-2-sgarzare@redhat.com>
 <202008261241.074D8765@keescook>
 <C1F49852-C886-4522-ACD6-DDBF7DE3B838@dilger.ca>
MIME-Version: 1.0
In-Reply-To: <C1F49852-C886-4522-ACD6-DDBF7DE3B838@dilger.ca>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 26, 2020 at 01:52:38PM -0600, Andreas Dilger wrote:
> On Aug 26, 2020, at 1:43 PM, Kees Cook <keescook@chromium.org> wrote:
> > 
> > On Thu, Aug 13, 2020 at 05:32:52PM +0200, Stefano Garzarella wrote:
> >> The enumeration allows us to keep track of the last
> >> io_uring_register(2) opcode available.
> >> 
> >> Behaviour and opcodes names don't change.
> >> 
> >> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >> ---
> >> include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
> >> 1 file changed, 16 insertions(+), 11 deletions(-)
> >> 
> >> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >> index d65fde732518..cdc98afbacc3 100644
> >> --- a/include/uapi/linux/io_uring.h
> >> +++ b/include/uapi/linux/io_uring.h
> >> @@ -255,17 +255,22 @@ struct io_uring_params {
> >> /*
> >>  * io_uring_register(2) opcodes and arguments
> >>  */
> >> -#define IORING_REGISTER_BUFFERS		0
> >> -#define IORING_UNREGISTER_BUFFERS	1
> >> -#define IORING_REGISTER_FILES		2
> >> -#define IORING_UNREGISTER_FILES		3
> >> -#define IORING_REGISTER_EVENTFD		4
> >> -#define IORING_UNREGISTER_EVENTFD	5
> >> -#define IORING_REGISTER_FILES_UPDATE	6
> >> -#define IORING_REGISTER_EVENTFD_ASYNC	7
> >> -#define IORING_REGISTER_PROBE		8
> >> -#define IORING_REGISTER_PERSONALITY	9
> >> -#define IORING_UNREGISTER_PERSONALITY	10
> >> +enum {
> >> +	IORING_REGISTER_BUFFERS,
> > 
> > Actually, one *tiny* thought. Since this is UAPI, do we want to be extra
> > careful here and explicitly assign values? We can't change the meaning
> > of a number (UAPI) but we can add new ones, etc? This would help if an
> > OP were removed (to stop from triggering a cascade of changed values)...
> > 
> > for example:
> > 
> > enum {
> > 	IORING_REGISTER_BUFFERS = 0,
> > 	IORING_UNREGISTER_BUFFERS = 1,
> > 	...
> 
> Definitely that is preferred, IMHO, for enums used as part of UAPI,
> as it avoids accidental changes to the values, and it also makes it
> easier to see what the actual values are.
> 

Sure, I agree.

I'll put the values in the enumerations in the v5.

Thanks,
Stefano

