Return-Path: <SRS0=DlMW=CF=lists.openwall.com=kernel-hardening-return-19698-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BB3C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:11:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 263722087D
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 14:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="VT257ly/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 263722087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19698-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14296 invoked by uid 550); 27 Aug 2020 14:11:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14269 invoked from network); 27 Aug 2020 14:11:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=etGmff5kjea2pYumFvnmRUd62aXV3Jnz4zFc8MdNedw=;
        b=VT257ly/Gi/sHNPTYqDt3YpqbEVFt/d4BM9TRuMzVg3+JUv1/v1DCMU7+QMWuChY8s
         b1p5uA8EnzQd8lo/7L/WuXpX234qc0mXNzM57pqrSHInoWgkqOLhM2UYewaqawhC8xs2
         /JATaHIrv9gRN6q5OwyC0zpbV8MrYvPYfPRrgSUIY5c7xpj2AzHpQ+9GWbamAj53fWdn
         IeXDsh5FTtNMD5PrcA8140uRXbLsq0eEhyqWzzAwR/z3Hh16IW5HhkceWImTFcsjSh0N
         B4HSMRW2OuXRO1u3iXOEWUD/HUY/3yuxS1JX9rZ/y2txqPH0FqMoeouoQ7oGg5U+3kGI
         219g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=etGmff5kjea2pYumFvnmRUd62aXV3Jnz4zFc8MdNedw=;
        b=gr8H/jUoKYSImwWvZtaeOl5jzO9CnUhhIZAERnm8TeHoBz69hE2Alj196rp9qcVCqS
         wvzoO1Qd5uyrHMzqUudf4jJljZfkuPtNDUFvYI33PgiGU8Xeq8HLI6Ph33JCmATOK0AI
         f7DrAxhIxxdeQ0JLZ8xrnNvcP18P8oNQ1teJ2ABxuw2wHCIuo5ERCrYYEtpTm2VRxr/V
         yrksd4sPF/sm5fwXlqb8nLwgG28XE/vAEWsNjx5eH7ZQH1mz85XASUQs71wWoB4x6qYe
         vdI74EWFYKPTbrY8L5vSLJ/WaYN63poN3/RI0vUf/NAjDUdQxabE+W2j6pl3CU9OmCRY
         qZ/g==
X-Gm-Message-State: AOAM530urg49ywyDoupnKxYRrqlXIAgBZxqCwzOKDzCKMQBI1NhtLVs7
	OYXvy971GyguWdIp5wgmRLUcUg==
X-Google-Smtp-Source: ABdhPJzM4CEH4kFINWPdYKqisNNlQjrNEp30gUUdhxYouGz8K5XQM7Wt2Ie5RxeKhyFHqad/dXvtng==
X-Received: by 2002:a92:9181:: with SMTP id e1mr16756233ill.274.1598537451548;
        Thu, 27 Aug 2020 07:10:51 -0700 (PDT)
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
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f7c0ff79-87c0-6c7e-b048-b82a45d0f44a@kernel.dk>
Date: Thu, 27 Aug 2020 08:10:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827141002.an34n2nx6m4dfhce@steredhat.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/27/20 8:10 AM, Stefano Garzarella wrote:
> On Thu, Aug 27, 2020 at 07:50:44AM -0600, Jens Axboe wrote:
>> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
>>> v5:
>>>  - explicitly assigned enum values [Kees]
>>>  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
>>>  - added Kees' R-b tags
>>>
>>> v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
>>> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
>>> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
>>> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
>>>
>>> Following the proposal that I send about restrictions [1], I wrote this series
>>> to add restrictions in io_uring.
>>>
>>> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
>>> available in this repository:
>>> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
>>>
>>> Just to recap the proposal, the idea is to add some restrictions to the
>>> operations (sqe opcode and flags, register opcode) to safely allow untrusted
>>> applications or guests to use io_uring queues.
>>>
>>> The first patch changes io_uring_register(2) opcodes into an enumeration to
>>> keep track of the last opcode available.
>>>
>>> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
>>> handle restrictions.
>>>
>>> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
>>> allowing the user to register restrictions, buffers, files, before to start
>>> processing SQEs.
>>>
>>> Comments and suggestions are very welcome.
>>
>> Looks good to me, just a few very minor comments in patch 2. If you
>> could fix those up, let's get this queued for 5.10.
>>
> 
> Sure, I'll fix the issues. This is great :-)

Thanks! I'll pull in your liburing tests as well once we get the kernel
side sorted.

-- 
Jens Axboe

