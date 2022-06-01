Return-Path: <kernel-hardening-return-21562-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 63733CCA473
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Jun 2022 15:42:13 +0000 (UTC)
Received: (qmail 5441 invoked by uid 550); 1 Jun 2022 15:42:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5406 invoked from network); 1 Jun 2022 15:42:02 -0000
Message-ID: <fd5cf4a3-ba98-5c98-f823-e83f58a1d40c@opteya.com>
Date: Wed, 1 Jun 2022 17:41:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Possibility of merge of disable icotl TIOCSTI patch
Content-Language: fr-FR
To: Simon Brand <simon.brand@postadigitale.de>,
 kernelnewbies@kernelnewbies.org, linux-hardening@vger.kernel.org,
 kernel-hardening@lists.openwall.com
References: <Yoy9IqTvch7lBwdT@hostpad>
From: Yann Droneaud <ydroneaud@opteya.com>
Organization: OPTEYA
In-Reply-To: <Yoy9IqTvch7lBwdT@hostpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Le 24/05/2022 à 13:10, Simon Brand a écrit :
> Hi,
>
> in the past there have been attempts to restrict the TIOCSTI ioctl. [0, 1]
> None of them are present in the current kernel.
> Since those tries there have been some security issues (sandbox
> escapes in flatpak (CVE-2019-10063) [2] and snap (CVE 2019-7303) [3],
> runuser [4], su [5]).
>
> I would provide a patch which leaves the current behavior as default,
> but TIOCSTI can be disabled via Kconfig or cmdline switch.
> Is there any chance this will get merged in 2022, since past
> attempts failed?
>
> Escapes can be reproduced easiliy (on archlinux) via a python script:
> ```
> import fcntl
> import termios
> with open("/dev/tty", "w") as fd:
>      for c in "id\n":
>          fcntl.ioctl(fd, termios.TIOCSTI, c)
> ```
> Now run as root:
> # su user
> $ python3 /path/to/script.py ; exit
> uid=0(root) ...
>
> Best,
> Simon
>
>
> [0] https://lkml.kernel.org/lkml/CAG48ez1NBnrsPnHN6D9nbOJP6+Q6zEV9vfx9q7ME4Eti-vRmhQ@mail.gmail.com/T/
> [1] https://lkml.kernel.org/lkml/20170420174100.GA16822@mail.hallyn.com/T/
> [2] https://github.com/flatpak/flatpak/issues/2782
> [3] https://wiki.ubuntu.com/SecurityTeam/KnowledgeBase/SnapIoctlTIOCSTI
> [4] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=815922
> [5] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=628843
>

This is probably some topic for (kernel|linux)-hardening@ mailing lists.


Regards.

-- 

Yann Droneaud

OPTEYA


