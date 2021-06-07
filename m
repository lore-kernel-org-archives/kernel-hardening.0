Return-Path: <SRS0=rOm2=LB=lists.openwall.com=kernel-hardening-return-21290-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB78CC47094
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Jun 2021 22:30:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ABFE761078
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Jun 2021 22:30:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABFE761078
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21290-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5476 invoked by uid 550); 7 Jun 2021 22:30:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3659 invoked from network); 7 Jun 2021 22:25:19 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=b6fHq6inNIhipW1ztkPlqvY4f9MP6CcM1fFIRec2g9Q=;
        b=X9DBHWpmfjvt8n6PWw6waSnYqnD9mMZ0qd/4bTV/+bquK7Mfskch+2WDFOzw3eU481
         0RWJGpHksfYHI9Unw0uSPhdIRDm41z7qJpPsfoJjXaM5jQXdLr/dgeyfMmMKEaO5yzZd
         +keJKRpfMsa/IX4utujN73kp0+QMGSS5euOjlxTTTUMiGkR6k3C+vVoiOgk9a6GsMDPM
         EzlQh+O+IzF16jb6LrtBTxyo6C4+sLVvpF1A7tqC8nd+8pvN/p1sYZFpVteyC/DtgxPi
         HTjBOIQFQuA5u28aKfesg7h94xO/79YiFaRmb+3FYGu1uC3bS2PnZSutcepS+oiRFWwx
         B8lg==
X-Gm-Message-State: AOAM533h6PZjQ1y+8T71n1VOmo3E+mfkFYhBveE/6JmRNFn49wWho6SA
	Ax1gRA56zhzFKGo/I0/+Vlu65nG5eRQmw4SyfAvAazmt86Tf
X-Google-Smtp-Source: ABdhPJwtAcTvPmWHX1yhNgZvplxVlg3Lq4Iy23LPMcdSinVbgK/jgNTPKiwR7uQG+A5JZN6RstwFjKbGZgb+FMJKPmXgZx7fH8dH
MIME-Version: 1.0
X-Received: by 2002:a92:c98b:: with SMTP id y11mr16544524iln.27.1623104707679;
 Mon, 07 Jun 2021 15:25:07 -0700 (PDT)
Date: Mon, 07 Jun 2021 15:25:07 -0700
In-Reply-To: <000000000000adea7f05abeb19cf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088dbd105c4348388@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in hci_chan_del
From: syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>
To: Jason@zx2c4.com, anmol.karan123@gmail.com, coiby.xu@gmail.com, 
	coreteam@netfilter.org, davem@davemloft.net, devel@driverdev.osuosl.org, 
	dsahern@kernel.org, dvyukov@google.com, eric@anholt.net, fw@strlen.de, 
	greg@kroah.com, gregkh@linuxfoundation.org, johan.hedberg@gmail.com, 
	kaber@trash.net, kadlec@blackhole.kfki.hu, kadlec@netfilter.org, 
	kernel-hardening@lists.openwall.com, kuba@kernel.org, 
	linux-bluetooth@vger.kernel.org, 
	linux-kernel-mentees@lists.linuxfoundation.org, linux-kernel@vger.kernel.org, 
	marcel@holtmann.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	pablo@netfilter.org, phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com, 
	syzscope@gmail.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 43016d02cf6e46edfc4696452251d34bba0c0435
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 3 11:51:15 2021 +0000

    netfilter: arptables: use pernet ops struct during unregister

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1325d967d00000
start commit:   af5043c8 Merge tag 'acpi-5.10-rc4' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9aa2432c01bcb1f
dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130152a1500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102b1bba500000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: arptables: use pernet ops struct during unregister

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
