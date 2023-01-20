Return-Path: <kernel-hardening-return-21599-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 28C4DC05027
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Jan 2023 22:50:38 +0000 (UTC)
Received: (qmail 13332 invoked by uid 550); 20 Jan 2023 22:50:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13312 invoked from network); 20 Jan 2023 22:50:26 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org E3C12AD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
	t=1674253497; bh=832X1wFeFvBP7zn6qg1MnTozywg+pZKIevCV58PkLuU=;
	h=Date:From:To:cc:Subject:From;
	b=2OvRPlLlu0IRwFkzk7r/g4QoHBpbqWNvQvLLAd2FjSSRQ6uTnF7VFpFfWdQljqLZ9
	 K0mp8sBsE3y6tP/GGTGqEJRSeyPNGKBVyggPNZ1agSJKeQ528q5mouUmCxAgh9G8bm
	 V0OqQUV/M4DT+zX+z0EyR7SGjqKsLz/n3bAbAhHk=
Date: Sat, 21 Jan 2023 09:24:57 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>, 
    lwn@lwn.net, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
    kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, 
    selinux@vger.kernel.org, Audit-ML <linux-audit@redhat.com>, 
    gentoo-hardened@gentoo.org, keyrings@linux-nfs.org, 
    tpmdd-devel@lists.sourceforge.net
Subject: [ANNOUNCE] Linux Security Summit North Americ (LSS-NA) CfP
Message-ID: <3a8f10eb-df2-cfad-1d-5aeab14568e@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

The Call for Participation for the 2023 LSS-NA conference is open!

See details of the event and information on submitting proposals here:
https://events.linuxfoundation.org/linux-security-summit-north-america/

LSS-NA 2023 will be in Vancouver, BC, Canada, from May 10th to May 12th. 
This will be a three day event, co-located with Open Source Summit North 
America [1].

The LSS-NA CfP is open until March 1st, 2023.


Note that announcements relating to the Linux Security Summit may be found 
now on the Fediverse, via: https://social.kernel.org/LinuxSecSummit


-- 
James Morris
<jmorris@namei.org>


[1] https://events.linuxfoundation.org/open-source-summit-north-america/
