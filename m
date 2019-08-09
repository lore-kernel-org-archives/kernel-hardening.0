Return-Path: <SRS0=4qCY=WF=lists.openwall.com=kernel-hardening-return-16776-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3BFC433FF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 13:46:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F75D2171F
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 13:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F75D2171F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16776-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13999 invoked by uid 550); 9 Aug 2019 13:46:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12039 invoked from network); 9 Aug 2019 13:44:01 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SVXw2/bA5C08+BykjuTS3dhz6TKyxWMjOdIKpXnFiF0=;
        b=cnAc8obpH2F7fg1gcXc4MCrG/3PtbL5kSVbMqYX4EkhpLUwKaTUOGmSUc5Uge9E6kd
         nHN+xgrqTKop22i+Q/w680X7iCQX3thMP/g4yjns5GrweZ1kI28yfa9WESPWfQGiU3BI
         xrya9giaGuMhif2JkAIicdfWPt5Q5xXoNDwUAmQ+KIosndXOhghnVR07AJRZFHW1s2uD
         m6yt5LM82k+pnhp4s7y7j8PFSVs9qsA1mPloeT85UKsv49VpZgwQVKp+nd8wBZU8xe/h
         0xTPy1dlIDHZ8nx77cjLRUqV6XnG+jRETTrWV+Y8LB9vvhFGKZyJbXKCkFzpxu+lX7KH
         PFJw==
X-Gm-Message-State: APjAAAUh39FItwp8feEjD41Xzp7cCAVdVhM8mc3P4O+q+9avLEBbjccC
	MbdgNNTftGZaDW6Q0W3bGgg=
X-Google-Smtp-Source: APXvYqzgfODOd8I82ICcOo3N3RU4p19HM2GuesacfNF1Br8xggXKcJZpItkDTk8yUNwJ/N/88Pfi3Q==
X-Received: by 2002:a5d:460a:: with SMTP id t10mr23215213wrq.83.1565358230117;
        Fri, 09 Aug 2019 06:43:50 -0700 (PDT)
Subject: Re: [PATCH] floppy: fix usercopy direction
To: Jens Axboe <axboe@kernel.dk>, alex.popov@linux.com,
 Jann Horn <jannh@google.com>
Cc: Jiri Kosina <jikos@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 Mukesh Ojha <mojha@codeaurora.org>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
 Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek
 <michal.lkml@markovi.net>, cocci@systeme.lip6.fr
References: <20190326220348.61172-1-jannh@google.com>
 <9ced7a06-5048-ad1a-3428-c8f943f7469c@linux.com>
 <b324719d-4cb4-89c9-ed00-2e0cd85ee375@kernel.dk>
From: Denis Efremov <efremov@linux.com>
Message-ID: <b509abcf-224b-7bfd-a792-dd8579dbcca9@linux.com>
Date: Fri, 9 Aug 2019 16:43:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b324719d-4cb4-89c9-ed00-2e0cd85ee375@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

>> So I add a new floppy maintainer Denis Efremov to CC.
> 
> Looks like it got lost indeed, I will just apply this one directly for
> 5.4.
> 

Thank you!

Denis
