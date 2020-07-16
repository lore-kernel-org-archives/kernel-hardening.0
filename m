Return-Path: <SRS0=JGbh=A3=lists.openwall.com=kernel-hardening-return-19368-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7793C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 20:52:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C590D20656
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 20:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S0tOe4di"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C590D20656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19368-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18093 invoked by uid 550); 16 Jul 2020 20:52:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13611 invoked from network); 16 Jul 2020 20:49:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Eqj9DsRh6gVjKvMX6P7OU0uqK/0x31oue4DPZYY3+g=;
        b=S0tOe4di3pZfE8TPqS58flVkFsQhYzhng0cSiQDKGIjcdgeSMR7S5LW6Il9mEg5BuA
         6ssEZVX/DZ55nmVXu5sg1/dONujPNo7qLQWNwS7XedeNpvGSucBtkdxJGfNYuQhvAejT
         memNfb3cu+iZndxMDZL4I8d5SLlSjpIMwiQoYk0zZLGEn/yynwVA0QK3tlgW1W5k+Fg3
         PMlcBaSI6AbNCErPQzcb0eJOHSmhARMxdcL8XdrqmSMZ3JFZCPBsQdXNM9ToSWrF8Yfr
         rfeX8m1HQjScgUoDg+UlFVQRUGBuFjMeNdcH5etrAweseZBY6kwgwsY18Q3dHAUcyo/5
         7ZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7Eqj9DsRh6gVjKvMX6P7OU0uqK/0x31oue4DPZYY3+g=;
        b=uE4hwELT4HqDLmdTAXbvmWmUgA+wqMQi6H96cfYBzeGNJa/eD05aBElFrBeikDH3AW
         6cYtrNRqyBuSeKNA+BBXVBb9rEcizad2zjzMdK8f4fr8fVGXdoQ0laAzS+i2IcD5IfAh
         3H47KzeWJUnrr167y9J77YqTPJVB3YiWfdGcp6sg3WC51EGi4kCOgBWsWOBj+sogex9c
         IZSKSTzf5q1Oweg/YiJF7sERuz/hJLyrAbyGuLNQp2PqN5u9TXD9HwreMfTy/NTgInH6
         uO2g3rKz5daOZjKHnJqPqp8QwpfiT04bcXmp4cQvEsmGUaX90/KMFVLefVKh/6NJa8VI
         WcDg==
X-Gm-Message-State: AOAM532+TOj2Th5aJgNKFDkHxzoeGzstI9TZUgAS/bL3MvKeE1QoENn7
	hFV6DfY6k7BIiBU16HKfABU=
X-Google-Smtp-Source: ABdhPJxSyrX2dc7t67bKHYl2rtGuILeM/JLQ964R+5CqhEIiKTEr/FdbuU+wjHpp+kttqkIpy6uF5A==
X-Received: by 2002:adf:ab46:: with SMTP id r6mr6746372wrc.260.1594932531211;
        Thu, 16 Jul 2020 13:48:51 -0700 (PDT)
Subject: Re: [PATCH RFC v2 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
To: Jens Axboe <axboe@kernel.dk>, Stefano Garzarella <sgarzare@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Kees Cook <keescook@chromium.org>, Aleksa Sarai <asarai@suse.de>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Sargun Dhillon <sargun@sargun.me>, Jann Horn <jannh@google.com>,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-2-sgarzare@redhat.com>
 <ca242a15-576d-4099-a5f8-85c08985e3ff@gmail.com>
 <a2f109b2-adbf-147d-9423-7a1a4bf99967@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <20326d79-fb5a-2480-e52a-e154e056171f@gmail.com>
Date: Thu, 16 Jul 2020 23:47:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a2f109b2-adbf-147d-9423-7a1a4bf99967@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 16/07/2020 23:42, Jens Axboe wrote:
> On 7/16/20 2:16 PM, Pavel Begunkov wrote:
>> On 16/07/2020 15:48, Stefano Garzarella wrote:
>>> The enumeration allows us to keep track of the last
>>> io_uring_register(2) opcode available.
>>>
>>> Behaviour and opcodes names don't change.
>>>
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> ---
>>>  include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
>>>  1 file changed, 16 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 7843742b8b74..efc50bd0af34 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -253,17 +253,22 @@ struct io_uring_params {
>>>  /*
>>>   * io_uring_register(2) opcodes and arguments
>>>   */
>>> -#define IORING_REGISTER_BUFFERS		0
>>> -#define IORING_UNREGISTER_BUFFERS	1
>>> -#define IORING_REGISTER_FILES		2
>>> -#define IORING_UNREGISTER_FILES		3
>>> -#define IORING_REGISTER_EVENTFD		4
>>> -#define IORING_UNREGISTER_EVENTFD	5
>>> -#define IORING_REGISTER_FILES_UPDATE	6
>>> -#define IORING_REGISTER_EVENTFD_ASYNC	7
>>> -#define IORING_REGISTER_PROBE		8
>>> -#define IORING_REGISTER_PERSONALITY	9
>>> -#define IORING_UNREGISTER_PERSONALITY	10
>>> +enum {
>>> +	IORING_REGISTER_BUFFERS,
>>> +	IORING_UNREGISTER_BUFFERS,
>>> +	IORING_REGISTER_FILES,
>>> +	IORING_UNREGISTER_FILES,
>>> +	IORING_REGISTER_EVENTFD,
>>> +	IORING_UNREGISTER_EVENTFD,
>>> +	IORING_REGISTER_FILES_UPDATE,
>>> +	IORING_REGISTER_EVENTFD_ASYNC,
>>> +	IORING_REGISTER_PROBE,
>>> +	IORING_REGISTER_PERSONALITY,
>>> +	IORING_UNREGISTER_PERSONALITY,
>>> +
>>> +	/* this goes last */
>>> +	IORING_REGISTER_LAST
>>> +};
>>
>> It breaks userspace API. E.g.
>>
>> #ifdef IORING_REGISTER_BUFFERS
> 
> It can, yes, but we have done that in the past. In this one, for

Ok, if nobody on the userspace side cares, then better to do that
sooner than later.


> example:
> 
> commit 9e3aa61ae3e01ce1ce6361a41ef725e1f4d1d2bf (tag: io_uring-5.5-20191212)
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Dec 11 15:55:43 2019 -0700
> 
>     io_uring: ensure we return -EINVAL on unknown opcod
> 
> But it would be safer/saner to do this like we have the done the IOSQE_
> flags.

IOSQE_ are a bitmask, but this would look peculiar

enum {
	__IORING_REGISTER_BUFFERS,
	...
};
define IORING_REGISTER_BUFFERS __IORING_REGISTER_BUFFERS

-- 
Pavel Begunkov
