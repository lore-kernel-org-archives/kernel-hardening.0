Return-Path: <SRS0=QBzb=CF=lists.openwall.com=kernel-hardening-return-19701-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D727C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:44:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8C3762087D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:44:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="aOAHV6uQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C3762087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19701-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5125 invoked by uid 550); 27 Aug 2020 14:44:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4081 invoked from network); 27 Aug 2020 14:44:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BvBnzh3obuyUM8uwyAg6+Zl7AVs2adJQvrnXXuqR/PQ=;
        b=aOAHV6uQAQVlX4aoMFWjdC9v57E5cC0AjZCtTF6GYcTrghuXOf8Fw6NLk/suxXkhU2
         zViUAl0NmIZa5ihE9PMDueIuiBFx5DOasGmrvktLc7e5r6OD+0oD9nDKl+0KvqGqIPFG
         BJgbssBNxa/kZTlS8BkLeqcQv9YXiLpmx5a1uN4P7h3oSSQxcwaKCwHZ165OdvIZC6Mf
         psv8Kta/q8Tz5GLxlrDhjSIyyxS9VAN9i/dZW1VxTUcPr5O+whKoDNqy6I5g64EB8ADD
         nEMZwCuBhJtzs7j4zgYA+Mf//9dosIRnf7H/UKL2qnhHQSkaeh0rjSiXZ/QXzYwKM4m+
         fCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BvBnzh3obuyUM8uwyAg6+Zl7AVs2adJQvrnXXuqR/PQ=;
        b=Fk5l/qaFl9Nr1DVo1VMRlRtQ+H8V4+A/NpTnG3K99s4nuwRnMiKm9AxB+6yrz2wdgy
         Bqlh6+Pt73XlcvWfhXgZaiNiSCWxaXHa2wPBeWmX9laHvhR3R5ciMArYxQtA8eUOyfaE
         8A1L7dKBLI0SMlL7IBtqmYhHIa7aVPvvHHg7gbgx/dxxaJESqgp5iNCGy/WeYYA6+zrF
         KZFSdRD0APeRcRPpUcqVxa5kl76dJXpjn/FpRPXLj2iWzycy6aTP+UZkbE0ErTBiQ0tY
         +olJCUgp6pPzs9DTdY6RwQpCZkqbUVFGKxJ44tavQn+B46VX+MvR3EJHjo/JMtAva4q9
         b5Fg==
X-Gm-Message-State: AOAM530afJfTNLH8wWO+4wJdp6ODfDlB3j7sB6Ds0EW9BtgMPjvCYx9t
	XoA4WI4YpnQRVxWuJQlCoVGV1A==
X-Google-Smtp-Source: ABdhPJyg0+F3rh8DdZSHIP0joxQ9ukHmLSGNjSdvxHsvaBjE+o6SG54bNvvUi1FkYKaS/9Wgb3eT1Q==
X-Received: by 2002:a92:dd8c:: with SMTP id g12mr16624564iln.184.1598539462409;
        Thu, 27 Aug 2020 07:44:22 -0700 (PDT)
Subject: Re: [PATCH v5 0/3] io_uring: add restrictions to support untrusted
 applications and guests
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Aleksa Sarai <asarai@suse.de>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
 Christian Brauner <christian.brauner@ubuntu.com>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
 Sargun Dhillon <sargun@sargun.me>, Kees Cook <keescook@chromium.org>,
 Jeff Moyer <jmoyer@redhat.com>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
 <20200827141002.an34n2nx6m4dfhce@steredhat.lan>
 <f7c0ff79-87c0-6c7e-b048-b82a45d0f44a@kernel.dk>
 <20200827144129.5yvu2icj7a5jfp3p@steredhat.lan>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d9363dfd-49da-b6ac-29f1-d8ba65665453@kernel.dk>
Date: Thu, 27 Aug 2020 08:44:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827144129.5yvu2icj7a5jfp3p@steredhat.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/27/20 8:41 AM, Stefano Garzarella wrote:
> On Thu, Aug 27, 2020 at 08:10:49AM -0600, Jens Axboe wrote:
>> On 8/27/20 8:10 AM, Stefano Garzarella wrote:
>>> On Thu, Aug 27, 2020 at 07:50:44AM -0600, Jens Axboe wrote:
>>>> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
>>>>> v5:
>>>>>  - explicitly assigned enum values [Kees]
>>>>>  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
>>>>>  - added Kees' R-b tags
>>>>>
>>>>> v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
>>>>> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
>>>>> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
>>>>> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
>>>>>
>>>>> Following the proposal that I send about restrictions [1], I wrote this series
>>>>> to add restrictions in io_uring.
>>>>>
>>>>> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
>>>>> available in this repository:
>>>>> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
>>>>>
>>>>> Just to recap the proposal, the idea is to add some restrictions to the
>>>>> operations (sqe opcode and flags, register opcode) to safely allow untrusted
>>>>> applications or guests to use io_uring queues.
>>>>>
>>>>> The first patch changes io_uring_register(2) opcodes into an enumeration to
>>>>> keep track of the last opcode available.
>>>>>
>>>>> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
>>>>> handle restrictions.
>>>>>
>>>>> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
>>>>> allowing the user to register restrictions, buffers, files, before to start
>>>>> processing SQEs.
>>>>>
>>>>> Comments and suggestions are very welcome.
>>>>
>>>> Looks good to me, just a few very minor comments in patch 2. If you
>>>> could fix those up, let's get this queued for 5.10.
>>>>
>>>
>>> Sure, I'll fix the issues. This is great :-)
>>
>> Thanks! I'll pull in your liburing tests as well once we get the kernel
>> side sorted.
> 
> Yeah. Let me know if you'd prefer that I send patches on io-uring ML.
> 
> About io-uring UAPI, do you think we should set explicitly the enum
> values also for IOSQE_*_BIT and IORING_OP_*?
> 
> I can send a separated patch for this.

No, I actually think that change was a little bit silly. If you
inadvertently renumber the enum in a patch, then tests would fail left
and right. Hence I don't think this is a real risk. I'm fine with doing
it for the addition, but doing it for the others is just going to cause
stable headaches for patches.

-- 
Jens Axboe

