Return-Path: <kernel-hardening-return-21655-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A0F37C77B61
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Apr 2023 10:06:24 +0000 (UTC)
Received: (qmail 22318 invoked by uid 550); 10 Apr 2023 10:06:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22284 invoked from network); 10 Apr 2023 10:06:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681121162;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATMiUtX64qR0hwTrZDgb3RHiSTdBt+7AzkUE71TDEpA=;
        b=gct+lbvYlrtdNbqog/h6bLfpEnPaE247rt+vXA19R+KcjQa2tfFmZW17wCi4DI9Ti1
         hf5KHwycpKXUFQWY4eUvBpNGZq/47owrFhn85GJ9S6WEvuSsOJBYMo1UUfExhdZzPj0U
         tvOZsbj2dKAnPc5e8c57rBnL4OcmZ1vcUf1DJWX7vPWA1Mk3ItkqvapId+/mnH0FXCoU
         XeFC43Ej3DdXAc178xiG7+75caZijBIu3eBZni+DJ8PT7plHTJEwbJJ3eyhM1fEMSkkR
         7hxoV1avDx5u2igYk860iu5jn0l2Wx2U3/rYawuYr3rP7Wkqhj/HU0J22gWTf+JN6Mek
         /aBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681121162;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ATMiUtX64qR0hwTrZDgb3RHiSTdBt+7AzkUE71TDEpA=;
        b=IJjbpW8OSOAiyEXcq3oeG60xK/2QyKgnN71PwJGwQQFiP+20SXaYqS1qfcRX2bV/sU
         G+sPE3wr4yJV2Mc3rPcGUIpUD9Ws4Bcv5D418x6WRxo1FInqWOFSl0XzXTyAl59Q55x8
         3j9NP/kodqvUC4C7rjuBZFW+mNIQLc5z0+od5+nqCfzKlOPB74nPSflj18rPQWEZLG/l
         Cw05KIlbWTDnCHdbg3H1gD9+F/MRDalkXgXSHkHH3TlIfd/zXkaTYkZ6GB5ZwNz1v7KQ
         KX4ly+1ehO7ePFT9CaS02sBSpVb/DeTjx6MBciNCRNmSPhqDZi2l2CJtBxusSCHUm1jv
         i+8Q==
X-Gm-Message-State: AAQBX9d6c4TbuX8FN1uuzL3tzFT06yb/RFCiaH2EN5KyIz4EvivUBHbj
	6lZlJz5zTvuhj6xIQj75xOhLDNv7dSY=
X-Google-Smtp-Source: AKy350YPnoDYffi3mvhIikGdK6c67KY+WRWZhkyE4MK7NQ5GJr5B2lpdmBmV9SkFOP/gf5oNz80bJg==
X-Received: by 2002:ac2:42c6:0:b0:4dd:cbf3:e981 with SMTP id n6-20020ac242c6000000b004ddcbf3e981mr2448219lfl.28.1681121162052;
        Mon, 10 Apr 2023 03:06:02 -0700 (PDT)
Message-ID: <640c4327-0b40-f964-0b5b-c978683ac9ba@gmail.com>
Date: Mon, 10 Apr 2023 13:06:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To: linux-modules <linux-modules@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Topi Miettinen <toiwoton@gmail.com>
Subject: Per-process flag set via prctl() to deny module loading?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I'd propose to add a per-process flag to irrevocably deny any loading of 
kernel modules for the process and its children. The flag could be set 
(but not unset) via prctl() and for unprivileged processes, only when 
NoNewPrivileges is also set. This would be similar to CAP_SYS_MODULE, 
but unlike capabilities, there would be no issues with namespaces since 
the flag isn't namespaced.

The implementation should be very simple.

Preferably the flag, when configured, would be set by systemd, Firejail 
and maybe also container managers. The expectation would be that the 
permission to load modules would be retained only by udev and where SUID 
needs to be allowed (NoNewPrivileges unset).

-Topi
