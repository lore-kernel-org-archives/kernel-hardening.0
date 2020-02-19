Return-Path: <SRS0=MTeY=4H=lists.openwall.com=kernel-hardening-return-17845-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349EFC34051
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 14:02:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5DDBE2176D
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 14:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YvAWDXz1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DDBE2176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17845-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20069 invoked by uid 550); 19 Feb 2020 14:02:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13421 invoked from network); 19 Feb 2020 13:44:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L8ptdDalwyG6uMw6RicIjSVjMH6+ERtlRGJ+jVIbCuo=;
        b=YvAWDXz11gdMN7LoYmyB+/QJYrJ/22oIVhhnCWDLW+GrhKkCQ7nJIcD5UML1Ezot/k
         igb0+0BC0ccprJJR8wggAbhllhF3gI5O8xYNrwoDwssi0tQj1MWr8t/MaU3behJ6P7uO
         asJyJ2aMcuBx5Tl34u3NLgTeNkwR7Q3AnQ5/8EV9vlRrEn1cVPYH04qkfRhn3Y0RP1sb
         ITcYTRVQe2npidgFO79e6X6C4eHOcfyRnWMgYrjZYkT79ZZ8l+ZPq/kyvknFaZbA5CEd
         sKj90uPw1LmpoXMPnxWnzNbrn7Vqa424BUrh40A54I8zVQHzUH+Gjviz3igiIF7o6/g/
         IjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=L8ptdDalwyG6uMw6RicIjSVjMH6+ERtlRGJ+jVIbCuo=;
        b=izeRa57Z7pJ6xby8vXIVzhb5kRZsk+xYwV6GTeFmGfvF7Ui13xVlGuzIfoy5Ve3RrS
         njqhH2N6N2es8lnf/xzDpwTJstg6cj+649ch1SCOv4w9QEkECKdLTZ9AXenzfsjkQmsj
         6xCG69/SrcsIQ/ATCe6FFrWrSwGD3AGrVbHBmdonzhp+zf9Gw4MScHEehLVGUJ63sgT8
         kEd97sQaglIWr7vo5h3CGoLcyXjf8rbv+GWxgC4Akz+/L9Jw8V4tL7YpJGh6t8IK5JA0
         nSUGZ4xOUoNqTVEyOFw7Q0vLaCO/X0xsPFgoTKcrHWOzp+XMkAv7RzGRccKCWSVNhSj1
         t6Iw==
X-Gm-Message-State: APjAAAWu51RfyP3fdXUsTYOuXCFp0DiOg8hDiS7QnHVZ5H5U5DlxTn0n
	WjppRPcG99b9RIJbwqh+NG4=
X-Google-Smtp-Source: APXvYqxDv898uoSDblvoS5vgMIbHSZpsKFZAWb7f+ALWL2x9ukpLWezHxdECLHDNgpZViFvuACVS/Q==
X-Received: by 2002:a17:90a:c705:: with SMTP id o5mr8954829pjt.67.1582119851669;
        Wed, 19 Feb 2020 05:44:11 -0800 (PST)
From: zerons <zeronsaxm@gmail.com>
To: alex.popov@linux.com
Cc: Andrey Konovalov <andreyknvl@google.com>,
 kernel-hardening@lists.openwall.com, Shawn <citypw@hardenedlinux.org>,
 spender@grsecurity.net, Jann Horn <jannh@google.com>
References: <e535d698-5268-e5fc-a238-0649c509cc4f@gmail.com>
 <CAAeHK+y-FdpH20Z7HsB0U+mgD9CK0gECCqShXFtFWpFp01jAmA@mail.gmail.com>
 <84b3a89a-cd20-1e49-8d98-53b74dd3f9d1@linux.com>
Openpgp: preference=signencrypt
Autocrypt: addr=zeronsaxm@gmail.com; prefer-encrypt=mutual; keydata=
 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
Subject: Re: Maybe inappropriate use BUG_ON() in CONFIG_SLAB_FREELIST_HARDENED
Message-ID: <68e01bc3-f218-01a1-2398-ec51ffa11109@gmail.com>
Date: Wed, 19 Feb 2020 21:43:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <84b3a89a-cd20-1e49-8d98-53b74dd3f9d1@linux.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit


> There was a linked list with data buffers, and one of these buffers was added to
> the list twice. Double free happened when the driver cleaned up its resources
> and freed the buffers in this list. So double kfree() happened quite close to
> each other.
> 
> I spent a lot of time trying to insert some kmalloc() between these kfree(), but

I did this too. :D

> didn't succeed. That is difficult because slab caches are per-CPU, and heap
> spray on other CPUs doesn't overwrite the needed kernel address.
> 
> The vulnerable kernel task didn't call scheduler between double kfree(). I
> didn't manage to preempt it. But I solved that trouble by spraying _after_
> double kfree().
> 
>>> Without this extra detection, the kernel could be unstable while the attacker
>>> trying to do the race.
> 
> Could you bring more details? Which kind of instability do you mean?
> 

Unlike cve-2017-2636 kind of double free bugs, assume that we have
another double free bug that would be stopped by this patch.

Now, the problem is, do we really have this kind of bugs that we could
win the race? I am not sure for now. Here is an example in Jann Horn's
latest article I read days ago. Though this example is not good enough
because the hlist operations may crash the kernel before double kfree(),
we should notice that some codes still can give us a chance.

(https://googleprojectzero.blogspot.com/2020/02/mitigations-are-attack-surface-too.html)
there could be a double free.
================================================================================
  spin_lock_irqsave(&table->pid_map_lock, irqsave_flags);
  hlist_for_each_entry(descr, &table->pid_map[hash_key], pid_map_node) {
    if (pid == descr->task->pid) {
      target_task_descr = descr;
      break;
    }
  }
  spin_unlock_irqrestore(&table->pid_map_lock, irqsave_flags);
================================================================================
The victim object is found in a hlist, and that's all we do in this critical section.
Later, it gets freed.

"As long as the double free happens in a user process context, you can
retry triggering it until you succeed in winning the race to reallocate
the object (without causing slab freelist corruption, as it would have
had happened before SLAB_FREELIST_HARDENED)." Andrey Konovalov said.

This patch does work for cve-2017-2636 case, it is barely impossible to win the
race. My concern is based on an assumption: we do have a double kfree() bug and
we can win the race.

Best regards,
