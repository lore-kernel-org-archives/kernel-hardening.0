Return-Path: <SRS0=9ARg=BA=lists.openwall.com=kernel-hardening-return-19400-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D4EC433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Jul 2020 17:11:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C7F1F2065D
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Jul 2020 17:11:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="cgZg2f4s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7F1F2065D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19400-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7925 invoked by uid 550); 21 Jul 2020 17:11:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7905 invoked from network); 21 Jul 2020 17:11:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yWaQmsiCiZZZ3Uj8uamide4LdDUSTz+/SoKFonKhAb4=;
        b=cgZg2f4sd5KgzapbCbk47ql+PhAAt+zV2ric/v9iIjaESnZgeOgpZeGKtGwr7Guiqb
         7m/qpv9dJvOsT33Dm8kbaPrszNy/70thpJG4rBdFsKLft/Jd6dLWk34bU/WkZh0nk/ri
         chNuRg3DUWLT9xFsI7E71aiXfNNfuuYQqGrGsXweihhOrp+ZODIq6cevaSEBmiM0KTDB
         cji5uM5VWXCMUNLKEzcUlpghhGTQDBbq8mE1tVXpTiYOOjNdKBkdgSrEOufMx4gCrBOj
         0L7CSdIG+y0ec0mh5PV3bqTap3A1SOyjKieW48+lPV1Hkh9KX68w5QPASQxzdfId+iBK
         gmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yWaQmsiCiZZZ3Uj8uamide4LdDUSTz+/SoKFonKhAb4=;
        b=A18NFmc7g8hzhDM2zln0dxShrNGaA5Mxu3e35JSk/IqCB+Tj0C//HftXONubcN3Dmb
         qfio4PUZrt0ZxXIbM+m7z4zvN37uSkHzmADah45NTcCyDxjwljCrDVkhTEuAq1f9Krfl
         XywrHpEPLPbO7now9ICLCSxKPEyNSddfDXPLv0b4YgjxU2MvC/NJyxeWeKASrYgrvZu9
         a2TTTkvZALKyiN3rI3Ymu5ueImgfyE+qW8DeQqCllkLGDr4VDHy66B6tKwgBq98tLajH
         kFIpUbXJK5W2CUmD11Y4qSroJ4XE++B9xwHuAsfQjZLg3kBGZU6pFQpHgPg2Dw03J1zU
         53wQ==
X-Gm-Message-State: AOAM530HEE4/qWduZIjkYCNnyKyNHsSJ6PR0wHHZ/Fyq32t3Dj5jow1X
	mz7U63Qthkk2ubDVgNssnn15HA==
X-Google-Smtp-Source: ABdhPJz/BZFEORJm8VP+fSEBvPITI4MrX63+k47jktVuZG2VxxBRTWs5F6VJi5EgR+nyts+EBlISmA==
X-Received: by 2002:a92:8544:: with SMTP id f65mr29398838ilh.42.1595351479058;
        Tue, 21 Jul 2020 10:11:19 -0700 (PDT)
Subject: Re: [PATCH RFC v2 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Kees Cook <keescook@chromium.org>, Aleksa Sarai <asarai@suse.de>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Sargun Dhillon <sargun@sargun.me>, Jann Horn <jannh@google.com>,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-3-sgarzare@redhat.com>
 <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk>
 <20200721104009.lg626hmls5y6ihdr@steredhat>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <15f7fcf5-c5bb-7752-fa9a-376c4c7fc147@kernel.dk>
Date: Tue, 21 Jul 2020 11:11:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721104009.lg626hmls5y6ihdr@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 7/21/20 4:40 AM, Stefano Garzarella wrote:
> On Thu, Jul 16, 2020 at 03:26:51PM -0600, Jens Axboe wrote:
>> On 7/16/20 6:48 AM, Stefano Garzarella wrote:
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index efc50bd0af34..0774d5382c65 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -265,6 +265,7 @@ enum {
>>>  	IORING_REGISTER_PROBE,
>>>  	IORING_REGISTER_PERSONALITY,
>>>  	IORING_UNREGISTER_PERSONALITY,
>>> +	IORING_REGISTER_RESTRICTIONS,
>>>  
>>>  	/* this goes last */
>>>  	IORING_REGISTER_LAST
>>> @@ -293,4 +294,30 @@ struct io_uring_probe {
>>>  	struct io_uring_probe_op ops[0];
>>>  };
>>>  
>>> +struct io_uring_restriction {
>>> +	__u16 opcode;
>>> +	union {
>>> +		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
>>> +		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
>>> +	};
>>> +	__u8 resv;
>>> +	__u32 resv2[3];
>>> +};
>>> +
>>> +/*
>>> + * io_uring_restriction->opcode values
>>> + */
>>> +enum {
>>> +	/* Allow an io_uring_register(2) opcode */
>>> +	IORING_RESTRICTION_REGISTER_OP,
>>> +
>>> +	/* Allow an sqe opcode */
>>> +	IORING_RESTRICTION_SQE_OP,
>>> +
>>> +	/* Only allow fixed files */
>>> +	IORING_RESTRICTION_FIXED_FILES_ONLY,
>>> +
>>> +	IORING_RESTRICTION_LAST
>>> +};
>>> +
>>
>> Not sure I totally love this API. Maybe it'd be cleaner to have separate
>> ops for this, instead of muxing it like this. One for registering op
>> code restrictions, and one for disallowing other parts (like fixed
>> files, etc).
>>
>> I think that would look a lot cleaner than the above.
>>
> 
> Talking with Stefan, an alternative, maybe more near to your suggestion,
> would be to remove the 'struct io_uring_restriction' and add the
> following register ops:
> 
>     /* Allow an sqe opcode */
>     IORING_REGISTER_RESTRICTION_SQE_OP
> 
>     /* Allow an io_uring_register(2) opcode */
>     IORING_REGISTER_RESTRICTION_REG_OP
> 
>     /* Register IORING_RESTRICTION_*  */
>     IORING_REGISTER_RESTRICTION_OP
> 
> 
>     enum {
>         /* Only allow fixed files */
>         IORING_RESTRICTION_FIXED_FILES_ONLY,
> 
>         IORING_RESTRICTION_LAST
>     }
> 
> 
> We can also enable restriction only when the rings started, to avoid to
> register IORING_REGISTER_ENABLE_RINGS opcode. Once rings are started,
> the restrictions cannot be changed or disabled.

My concerns are largely:

1) An API that's straight forward to use
2) Something that'll work with future changes

The "allow these opcodes" is straightforward, and ditto for the register
opcodes. The fixed file I guess is the odd one out. So if we need to
disallow things in the future, we'll need to add a new restriction
sub-op. Should this perhaps be "these flags must be set", and that could
easily be augmented with "these flags must not be set"?

-- 
Jens Axboe

