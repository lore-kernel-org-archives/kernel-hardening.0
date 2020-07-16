Return-Path: <SRS0=Htyk=A3=lists.openwall.com=kernel-hardening-return-19369-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296A0C433E4
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 21:21:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7591920787
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 21:21:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="n8TtjlSg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7591920787
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19369-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32351 invoked by uid 550); 16 Jul 2020 21:21:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32330 invoked from network); 16 Jul 2020 21:21:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LEv+cQHA0XVbPMchrlnqMxvR2K1AYW3g6zK4UFsmFr4=;
        b=n8TtjlSgQK6zU0sdra5ATCoBC6aOE8/1mnUXbCo8BmXqg8Y12GIOpFWzYBy40wj23U
         JmoMk0rduLiaC+UVOW7D/nGGfwTrey+2CrevmYppsxQULo8eDxbunzsZNk0LLJ6HtOGq
         ZsscAzjF0679jB4Qb+S39HskAxrgsRKj9NoYzU+iFB/OVxvFtbwgib1KEwtVPGcaB6SG
         qp3z1ZJ7zcxrN121ZMsjZNknSEJCYp95O85MD4wG3pGulD20kBSlPl0xXhVLAQJgbXC6
         goO5rKY/VaWec0XlG3xAf+9pbAmCycTC5aJ9vYExN1xKg352hKcLAEpkifJF+Fryj3mZ
         coZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LEv+cQHA0XVbPMchrlnqMxvR2K1AYW3g6zK4UFsmFr4=;
        b=ZsFArURMUhdOMQKynG5G3Igcq7CA29UxD5u2sbQd+S1DIxk3F96XVXTseJKO1Ov44v
         2YyYU3nWpU5OWL07YoMjcfs2eJVxlJclg4TGg2bDYxS0MN+glOlWQpnRGC/Yiu32wfzr
         roiH3GlJwg/OVpcFfqBDKTxl654rLmQ6fyUIbzxOdNSlNyHZ1wX8v6acYNQYH2jgcUGp
         Du/p2DE9KpjO6wqHz+oeHsCY8FG1V+wuMxkvLaL44pYf6i/6lTB4Fkl9V6WFEfihztTH
         g01btHmqagveJxYQdlJTYLkEf05fzD4jd9kHjie02L8X6aKka565k5OwF7+u1T56VMWq
         1drA==
X-Gm-Message-State: AOAM530vQjNwm1WoLFgh8DsrIqUonY5ahXrLFZlLWi5BFZFycXivGdco
	qRxdEaS58D95F+pEP0NyuuO7lg==
X-Google-Smtp-Source: ABdhPJxkpXHzsahyntnkdfZ9wBuSP7clR/vwRWqejN6tIPNw6BoYR132PIZwKZWkDVV6KrHlU2MY5A==
X-Received: by 2002:a92:4913:: with SMTP id w19mr6104024ila.185.1594934455696;
        Thu, 16 Jul 2020 14:20:55 -0700 (PDT)
Subject: Re: [PATCH RFC v2 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Stefano Garzarella <sgarzare@redhat.com>
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
 <20326d79-fb5a-2480-e52a-e154e056171f@gmail.com>
 <76879432-745d-a5ca-b171-b1391b926ea2@kernel.dk>
Message-ID: <0357e544-d534-06d2-dc61-1169fc172d20@kernel.dk>
Date: Thu, 16 Jul 2020 15:20:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <76879432-745d-a5ca-b171-b1391b926ea2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 7/16/20 2:51 PM, Jens Axboe wrote:
> On 7/16/20 2:47 PM, Pavel Begunkov wrote:
>> On 16/07/2020 23:42, Jens Axboe wrote:
>>> On 7/16/20 2:16 PM, Pavel Begunkov wrote:
>>>> On 16/07/2020 15:48, Stefano Garzarella wrote:
>>>>> The enumeration allows us to keep track of the last
>>>>> io_uring_register(2) opcode available.
>>>>>
>>>>> Behaviour and opcodes names don't change.
>>>>>
>>>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>>> ---
>>>>>  include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
>>>>>  1 file changed, 16 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>> index 7843742b8b74..efc50bd0af34 100644
>>>>> --- a/include/uapi/linux/io_uring.h
>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>> @@ -253,17 +253,22 @@ struct io_uring_params {
>>>>>  /*
>>>>>   * io_uring_register(2) opcodes and arguments
>>>>>   */
>>>>> -#define IORING_REGISTER_BUFFERS		0
>>>>> -#define IORING_UNREGISTER_BUFFERS	1
>>>>> -#define IORING_REGISTER_FILES		2
>>>>> -#define IORING_UNREGISTER_FILES		3
>>>>> -#define IORING_REGISTER_EVENTFD		4
>>>>> -#define IORING_UNREGISTER_EVENTFD	5
>>>>> -#define IORING_REGISTER_FILES_UPDATE	6
>>>>> -#define IORING_REGISTER_EVENTFD_ASYNC	7
>>>>> -#define IORING_REGISTER_PROBE		8
>>>>> -#define IORING_REGISTER_PERSONALITY	9
>>>>> -#define IORING_UNREGISTER_PERSONALITY	10
>>>>> +enum {
>>>>> +	IORING_REGISTER_BUFFERS,
>>>>> +	IORING_UNREGISTER_BUFFERS,
>>>>> +	IORING_REGISTER_FILES,
>>>>> +	IORING_UNREGISTER_FILES,
>>>>> +	IORING_REGISTER_EVENTFD,
>>>>> +	IORING_UNREGISTER_EVENTFD,
>>>>> +	IORING_REGISTER_FILES_UPDATE,
>>>>> +	IORING_REGISTER_EVENTFD_ASYNC,
>>>>> +	IORING_REGISTER_PROBE,
>>>>> +	IORING_REGISTER_PERSONALITY,
>>>>> +	IORING_UNREGISTER_PERSONALITY,
>>>>> +
>>>>> +	/* this goes last */
>>>>> +	IORING_REGISTER_LAST
>>>>> +};
>>>>
>>>> It breaks userspace API. E.g.
>>>>
>>>> #ifdef IORING_REGISTER_BUFFERS
>>>
>>> It can, yes, but we have done that in the past. In this one, for
>>
>> Ok, if nobody on the userspace side cares, then better to do that
>> sooner than later.

I actually don't think it's a huge issue. Normally if applications
do this, it's because they are using it and need it. Ala:

#ifndef IORING_REGISTER_SOMETHING
#define IORING_REGISTER_SOMETHING	fooval
#endif

and that'll still work just fine, even if an identical enum is there.

-- 
Jens Axboe

