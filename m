Return-Path: <SRS0=J4NW=A4=lists.openwall.com=kernel-hardening-return-19372-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7A1C433E2
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 08:14:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 89A5A2074B
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 08:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sqo0BbhB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89A5A2074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19372-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9812 invoked by uid 550); 17 Jul 2020 08:13:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9790 invoked from network); 17 Jul 2020 08:13:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1594973622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4AhK0Zzm0uakjm5OFnnhauntdAQG4ut12mfNiIODHdo=;
	b=Sqo0BbhBSmOj9HFvnWn8mIsbNWZdfPhmIooyltBHmZ0fwQLPX7H0BH95W/hAH7/bhhXIh6
	lLo6+kYv53H1ujz3olCxss0XIAkTSTDzh7hnY+836wQ23a6oNYXflwlb3p+WlA6O+PfCQo
	PVdJUbjl1PCEWuz34AKwpWCcbL0m1rI=
X-MC-Unique: EQZLTHwnMyKN-Mf9EZrtlQ-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4AhK0Zzm0uakjm5OFnnhauntdAQG4ut12mfNiIODHdo=;
        b=WhxoergaCIs8DPG5l/YxhNBRSl+wpxrrEqoxakUmrvj7fkrD1r/bEisGxPLIDGEzD8
         jVt84ZqV4xtUgJfSIln0TAtyjGBjCGal87obDma5jZ/i1EUGoGZ5PXf3p+27oyBlBWVz
         stKiSpwhbIkH8bu/inLrHopy2KzBncU9zPNSarIYrFPnff1gQrZAnMjSG9EFIYMD4aT+
         IRar6OooBouSdNyUra70sA+ddmg4qpKB48awa213P8LXiHVLDAIRjX7lQI4qCucevVdu
         4z527tkmBv98SmX8sK4QyVraJv7rn7jwO021jYyyROMDlI1ytfHwmYU3I0wOgOM8spMo
         RTyw==
X-Gm-Message-State: AOAM533gxh/nhvug87vFIvfko3X5yI+5/xpEQVJ+zE3S7kNFjbyEGcrd
	HQKLnzQoy7sdd/eX6EpZlwxiW2nlD/NoPnnJq1cAun5PrRCZu282LtRVte77k4MVKrVtZ1XDtCW
	LAS0rXj3b6IzfbSSWaonrA7+WckGhZoMnOg==
X-Received: by 2002:a1c:9e4c:: with SMTP id h73mr8623600wme.177.1594973619424;
        Fri, 17 Jul 2020 01:13:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeW6RsdiE3kyUT5zs2nMNiDhKPd7zXn+E25Grakr6B0wzn0S3WYa0J8I4e51M3iaPMLfxKUA==
X-Received: by 2002:a1c:9e4c:: with SMTP id h73mr8623586wme.177.1594973619210;
        Fri, 17 Jul 2020 01:13:39 -0700 (PDT)
Date: Fri, 17 Jul 2020 10:13:33 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Kees Cook <keescook@chromium.org>, Aleksa Sarai <asarai@suse.de>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Sargun Dhillon <sargun@sargun.me>, Jann Horn <jannh@google.com>,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
Message-ID: <20200717081333.6z6rtwx3jtktwdvp@steredhat.lan>
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-2-sgarzare@redhat.com>
 <ca242a15-576d-4099-a5f8-85c08985e3ff@gmail.com>
 <a2f109b2-adbf-147d-9423-7a1a4bf99967@kernel.dk>
 <20326d79-fb5a-2480-e52a-e154e056171f@gmail.com>
 <76879432-745d-a5ca-b171-b1391b926ea2@kernel.dk>
 <0357e544-d534-06d2-dc61-1169fc172d20@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <0357e544-d534-06d2-dc61-1169fc172d20@kernel.dk>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 16, 2020 at 03:20:53PM -0600, Jens Axboe wrote:
> On 7/16/20 2:51 PM, Jens Axboe wrote:
> > On 7/16/20 2:47 PM, Pavel Begunkov wrote:
> >> On 16/07/2020 23:42, Jens Axboe wrote:
> >>> On 7/16/20 2:16 PM, Pavel Begunkov wrote:
> >>>> On 16/07/2020 15:48, Stefano Garzarella wrote:
> >>>>> The enumeration allows us to keep track of the last
> >>>>> io_uring_register(2) opcode available.
> >>>>>
> >>>>> Behaviour and opcodes names don't change.
> >>>>>
> >>>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >>>>> ---
> >>>>>  include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
> >>>>>  1 file changed, 16 insertions(+), 11 deletions(-)
> >>>>>
> >>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >>>>> index 7843742b8b74..efc50bd0af34 100644
> >>>>> --- a/include/uapi/linux/io_uring.h
> >>>>> +++ b/include/uapi/linux/io_uring.h
> >>>>> @@ -253,17 +253,22 @@ struct io_uring_params {
> >>>>>  /*
> >>>>>   * io_uring_register(2) opcodes and arguments
> >>>>>   */
> >>>>> -#define IORING_REGISTER_BUFFERS		0
> >>>>> -#define IORING_UNREGISTER_BUFFERS	1
> >>>>> -#define IORING_REGISTER_FILES		2
> >>>>> -#define IORING_UNREGISTER_FILES		3
> >>>>> -#define IORING_REGISTER_EVENTFD		4
> >>>>> -#define IORING_UNREGISTER_EVENTFD	5
> >>>>> -#define IORING_REGISTER_FILES_UPDATE	6
> >>>>> -#define IORING_REGISTER_EVENTFD_ASYNC	7
> >>>>> -#define IORING_REGISTER_PROBE		8
> >>>>> -#define IORING_REGISTER_PERSONALITY	9
> >>>>> -#define IORING_UNREGISTER_PERSONALITY	10
> >>>>> +enum {
> >>>>> +	IORING_REGISTER_BUFFERS,
> >>>>> +	IORING_UNREGISTER_BUFFERS,
> >>>>> +	IORING_REGISTER_FILES,
> >>>>> +	IORING_UNREGISTER_FILES,
> >>>>> +	IORING_REGISTER_EVENTFD,
> >>>>> +	IORING_UNREGISTER_EVENTFD,
> >>>>> +	IORING_REGISTER_FILES_UPDATE,
> >>>>> +	IORING_REGISTER_EVENTFD_ASYNC,
> >>>>> +	IORING_REGISTER_PROBE,
> >>>>> +	IORING_REGISTER_PERSONALITY,
> >>>>> +	IORING_UNREGISTER_PERSONALITY,
> >>>>> +
> >>>>> +	/* this goes last */
> >>>>> +	IORING_REGISTER_LAST
> >>>>> +};
> >>>>
> >>>> It breaks userspace API. E.g.
> >>>>
> >>>> #ifdef IORING_REGISTER_BUFFERS
> >>>
> >>> It can, yes, but we have done that in the past. In this one, for
> >>
> >> Ok, if nobody on the userspace side cares, then better to do that
> >> sooner than later.
> 
> I actually don't think it's a huge issue. Normally if applications
> do this, it's because they are using it and need it. Ala:
> 
> #ifndef IORING_REGISTER_SOMETHING
> #define IORING_REGISTER_SOMETHING	fooval
> #endif
> 
> and that'll still work just fine, even if an identical enum is there.
> 

Thank you both for the review!

Then if you agree, I'll leave this patch as it is by introducing the enum.

Stefano

