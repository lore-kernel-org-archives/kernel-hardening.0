Return-Path: <SRS0=oc+F=CD=lists.openwall.com=kernel-hardening-return-19663-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5EDC433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Aug 2020 15:21:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4B11920786
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Aug 2020 15:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DZmmDwPb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B11920786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19663-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11728 invoked by uid 550); 25 Aug 2020 15:21:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11708 invoked from network); 25 Aug 2020 15:21:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598368856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ww29tGGGCJNK0uYcOWj2E3kj6GiHCX868VNsZmxKCg=;
	b=DZmmDwPbjFNBK1CnTkc7W1gCkwYnXPDPXIGqdiID6wz62a4higGYfhTWB96CaBloWWJmuy
	25PR3l/G+ujvi6h9ytSIvIOovq95LEri88oYueTUA22Z00NCSMlnllUkTfQDDpT9fi/ZuI
	Mc9Gju94rPJbScCx8TBPtAsY7yawdGk=
X-MC-Unique: BZp0ycNqPnS0GM2O2fG2eg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/ww29tGGGCJNK0uYcOWj2E3kj6GiHCX868VNsZmxKCg=;
        b=SO/CKMxzGTQuGej+l8Sxouf5bCudQ9jmTcB6tNIlVOlbd4rQMoGadIo/iG5trmdAB7
         /5qtNqk5XMa/OhGys1T98gs37NjGck2gfYfnunGsALDDRDRE5XQLK5PSEYqQXyUk0Z2Q
         pujOOBl0DhZDP0DYnpKZzg261JGVPF8N3UUaYG7OjQpaVp1JR3cm27C1dfo+22tFebJW
         3jiUi197QlvCfQ1NZXb7unVl3f5aE0FImwbkARye7q2QB4JC/A4vKvopmGqQJ9RTXGL1
         QCDrnQ4Rdb56F9MQMF8cKWOmrj4CBc9gsZve7IC4Sg4qxfRkCbkHIBgG3bqPBVMFYnGT
         jz8Q==
X-Gm-Message-State: AOAM531qsVNaPtWsxqwJpQAwiBLUedE0fLqLCcYSQMb3Ojj1kougHPOQ
	8XmRJ5c0EMCrRIssgsja99zhn7RfINy7PUFAa+5PpC/f8JG3xCyuLVR+4mnpOnQ0FTZ8aWZRRkd
	TVRyppNXMyBjTQrcgiNECZocnbAxDA0SIHw==
X-Received: by 2002:adf:f149:: with SMTP id y9mr10788353wro.93.1598368848123;
        Tue, 25 Aug 2020 08:20:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFcOj3KLiVhLrb5kKPj9J8yKhtonxgeHvdnpuzUycgw3vzeJpSYbKYVTAeVF3IvMjryZZqFg==
X-Received: by 2002:adf:f149:: with SMTP id y9mr10788321wro.93.1598368847815;
        Tue, 25 Aug 2020 08:20:47 -0700 (PDT)
Date: Tue, 25 Aug 2020 17:20:44 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Aleksa Sarai <asarai@suse.de>, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <CAGxU2F55zzMzc043P88TWJNr2poUTVwrRmu86qyh0uM-8gimng@mail.gmail.com>
References: <20200813153254.93731-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200813153254.93731-1-sgarzare@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sgarzare@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jens,
this is a gentle ping.

I'll respin, using memdup_user() for restriction registration.
I'd like to get some feedback to see if I should change anything else.

Do you think it's in good shape?

Thanks,
Stefano

On Thu, Aug 13, 2020 at 5:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> v4:
>  - rebased on top of io_uring-5.9
>  - fixed io_uring_enter() exit path when ring is disabled
>
> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.c=
> om/
> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redh=
> at.com
> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@red=
> hat.com
>
> Following the proposal that I send about restrictions [1], I wrote this series
> to add restrictions in io_uring.
>
> I also wrote helpers in liburing and a test case (test/register-restrictions.=
> c)
> available in this repository:
> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
>
> Just to recap the proposal, the idea is to add some restrictions to the
> operations (sqe opcode and flags, register opcode) to safely allow untrusted
> applications or guests to use io_uring queues.
>
> The first patch changes io_uring_register(2) opcodes into an enumeration to
> keep track of the last opcode available.
>
> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> handle restrictions.
>
> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> allowing the user to register restrictions, buffers, files, before to start
> processing SQEs.
>
> Comments and suggestions are very welcome.
>
> Thank you in advance,
> Stefano
>
> [1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredha=
> t/
>
> Stefano Garzarella (3):
>   io_uring: use an enumeration for io_uring_register(2) opcodes
>   io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
>   io_uring: allow disabling rings during the creation
>
>  fs/io_uring.c                 | 160 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/io_uring.h |  60 ++++++++++---
>  2 files changed, 203 insertions(+), 17 deletions(-)
>
> --=20
> 2.26.2
>

