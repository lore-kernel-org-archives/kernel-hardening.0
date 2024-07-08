Return-Path: <kernel-hardening-return-21762-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id CD66BC3DA41
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 19:42:01 +0000 (UTC)
Received: (qmail 5597 invoked by uid 550); 8 Jul 2024 19:41:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5576 invoked from network); 8 Jul 2024 19:41:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:mime-version:content-transfer-encoding; s=pp1; bh=
	PI6ioTZxN04v0o4ledQDCL/DhPKUMfb+Yex2f/zaul8=; b=pBxDm61hkqLjxCJk
	JASTnWQtzszY0tjxylrO0PcfEt+PMQ5sSK+JqVvg5adHJQm5HkDYcCGubdZr34XZ
	5YO6B/LmRQ1WVrV1YAmkuTuGb+ud5nlso6xkVkpRQTB2WnHHB8wLMVcoVySFjW9f
	fw3sGNH7dfELCRvRaSsWlI8uv/BbX3Ket//XxVLZE37rvk6VjO3tvZS8DwMjTvI2
	ZhZNY6NLaqFzv+FBwbdIId99I28788IYOolAvnxD8Zhqtzi3o27xbvEn68yCKMn9
	HgarhQX4h11doRgEmLu3sy1Dqy/qSU0MYWhoI7PUa92iAJL2FRvt/yzcXTAAm5ZC
	b5ddxg==
Message-ID: <968619d912ee5a57aed6c73218221ef445a0766e.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v19 5/5] samples/should-exec: Add set-should-exec
From: Mimi Zohar <zohar@linux.ibm.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Al Viro
 <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Kees
 Cook <keescook@chromium.org>,
        Linus Torvalds
 <torvalds@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: Alejandro Colomar <alx.manpages@gmail.com>,
        Aleksa Sarai
 <cyphar@cyphar.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy
 Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Casey
 Schaufler <casey@schaufler-ca.com>,
        Christian Heimes
 <christian@python.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Biggers
 <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Fan Wu
 <wufan@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        Geert
 Uytterhoeven <geert@linux-m68k.org>,
        James Morris
 <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>,
        Jann Horn
 <jannh@google.com>, Jeff Xu <jeffxu@google.com>,
        Jonathan Corbet
 <corbet@lwn.net>,
        Jordan R Abrahams <ajordanr@google.com>,
        Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,
        Luca Boccassi
 <bluca@debian.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Madhavan T .
 Venkataraman" <madvenka@linux.microsoft.com>,
        Matt Bobrowski
 <mattbobrowski@google.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew
 Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Nicolas
 Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
        Scott Shell
 <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
        Stephen Rothwell
 <sfr@canb.auug.org.au>,
        Steve Dower <steve.dower@python.org>, Steve Grubb
 <sgrubb@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        Xiaoming Ni
 <nixiaoming@huawei.com>,
        Yin Fengwei <fengwei.yin@intel.com>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Mon, 08 Jul 2024 15:40:42 -0400
In-Reply-To: <20240704190137.696169-6-mic@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
	 <20240704190137.696169-6-mic@digikod.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-26.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VO5yoT2dlibPVoAEHzj2-jvwByEHNf3c
X-Proofpoint-GUID: EkD-14ayMXpWdF4pXXJN3yYQbzTtIXSW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-08_10,2024-07-05_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0 clxscore=1011
 adultscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 mlxlogscore=886
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407080146

Hi Mickaël,

On Thu, 2024-07-04 at 21:01 +0200, Mickaël Salaün wrote:
> Add a simple tool to set SECBIT_SHOULD_EXEC_CHECK,
> SECBIT_SHOULD_EXEC_RESTRICT, and their lock counterparts before
> executing a command.  This should be useful to easily test against
> script interpreters.

The print_usage() provides the calling syntax.  Could you provide an example of
how to use it and what to expect?

thanks,

Mimi

