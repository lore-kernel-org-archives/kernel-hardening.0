Return-Path: <SRS0=cZWD=4B=lists.openwall.com=kernel-hardening-return-17814-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564B6C2BA83
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Feb 2020 15:43:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 80BFA20661
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Feb 2020 15:43:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="szqaH6F+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80BFA20661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17814-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1661 invoked by uid 550); 13 Feb 2020 15:43:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21586 invoked from network); 13 Feb 2020 15:16:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:openpgp:autocrypt:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=R6wZ+9kN01kbW6qYah4SnW1qlVhjsg7HEty8gNv5PAs=;
        b=szqaH6F+6S5dKkNEQExQ/JlUVohGu6ljJTj/3dflzZZb6Nj58PK6CEFerv6WaJnuqk
         dHJE2TEXFElxC87mJfn8+LeGzghvBYk4QjJCbhY1qO4ZToI5BKlzPm6NdNtB10tR8vm5
         XOEhHONp95rdI31pUfyt5BAXQgF4PsDK2uLBkqo4nb9ZYg9uQ1TTfxv5ABVdg7FrGI8R
         txmiXqSjZJObsvBctMujfqIY7eBL50UaxG97pI53487tt+PjogWT8ypWjyS3vtna5nMI
         PlLRV0M347ZE8BCMAsndizLA8q9GG1dC/BVB7+3WWvW5EUXaMhTsoSzQFgwzN97eGZXj
         qH9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:openpgp:autocrypt:cc:subject:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=R6wZ+9kN01kbW6qYah4SnW1qlVhjsg7HEty8gNv5PAs=;
        b=m3zty9AsaDpyw1CTzAPMFJE91ghPi0rR2WTZVPAD8csUSNFgjN5XWSmPTn5ZOrJNCr
         S+t3GPsDyOSwqOBDiyWBpFXHgYVaNm6XiUXzRreDjvpDHw13ADwA5I5+4P8j3z0ERNM2
         /llynRp8tWYKXEEoNr2hmg0ovWwjrin9E26dMt/AqFwcLU1RyyxgClTHZ1Sk3lLjkPVx
         uZmzNP4Tasnpja0aGb0pOQzCiead9Lp79xQnNUNx9lCEzA1FEjo+Hg6PFVqiJHzt+8Mt
         /3XKkgzxFjzwJpCgzIYuLNSJ8/DDXS49rF5vTHmKSz8GuByw2YBePqrBZ3/hXY38G2bp
         mNJw==
X-Gm-Message-State: APjAAAV4oC/VdkTtp+GJdAiFRNkeznwZswUP/cyyJ2w52P/odwgP92vZ
	k9JT6TkWatGdrGXFwsa9Tkg=
X-Google-Smtp-Source: APXvYqzVfdmMauBi9/B4vbF5NMyCVS/NFbXYd7ErFKuvyxSo7n8V2vi2gubr6V3X9Z13i5jd7bHkRg==
X-Received: by 2002:a63:4757:: with SMTP id w23mr15110603pgk.115.1581606989868;
        Thu, 13 Feb 2020 07:16:29 -0800 (PST)
To: kernel-hardening@lists.openwall.com
From: zerons <zeronsaxm@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=zeronsaxm@gmail.com; prefer-encrypt=mutual; keydata=
 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
Cc: Shawn <citypw@gmail.com>, spender@grsecurity.net
Subject: Maybe inappropriate use BUG_ON() in CONFIG_SLAB_FREELIST_HARDENED
Message-ID: <e535d698-5268-e5fc-a238-0649c509cc4f@gmail.com>
Date: Thu, 13 Feb 2020 23:16:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit

Hi,

In slub.c(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/slub.c?h=v5.4.19#n305),
for SLAB_FREELIST_HARDENED, an extra detection of the double free bug has been added.

This patch can (maybe only) detect something like this: kfree(a) kfree(a).
However, it does nothing when another process calls kfree(b) between the two kfree above.

The problem is, if the panic_on_oops option is not set(Ubuntu 16.04/18.04 default option),
for a bug which kfree an object twice in a row, if another process can preempt the process
triggered this bug and then call kmalloc() to get the object, the patch doesn't work.

Case 0: failure race
Process A:
	kfree(a)
	kfree(a)
the patch could terminate Process A.

Case 1: race done
Process A:
	kfree(a)
Process B:
	kmalloc() -> a
Process A:
	kfree(a)
the patch does nothing.

The attacker can check the return status of process A to see if the race is done.

Without this extra detection, the kernel could be unstable while the attacker
trying to do the race.
In my opinion, this patch can somehow help attacker exploit this kind of bugs
more reliable.

Best Regards,
