Return-Path: <SRS0=IVUh=6W=lists.openwall.com=kernel-hardening-return-18740-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F626C38A2A
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 May 2020 14:02:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DB7BD20736
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 May 2020 14:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB7BD20736
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18740-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6121 invoked by uid 550); 8 May 2020 14:02:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6095 invoked from network); 8 May 2020 14:02:10 -0000
Message-ID: <1588946467.5146.6.camel@linux.ibm.com>
Subject: Re: [PATCH v5 0/6] Add support for O_MAYEXEC
From: Mimi Zohar <zohar@linux.ibm.com>
To: "Lev R. Oshvang ." <levonshe@gmail.com>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?=
	 <mic@digikod.net>
Cc: David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>, Alexei
 Starovoitov <ast@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Andy
 Lutomirski <luto@kernel.org>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Deven Bowers
 <deven.desai@linux.microsoft.com>,
        Eric Chiang <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
        Jan
 Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
        Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,
        Matthew Garrett
 <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk
 <mtk.manpages@gmail.com>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?=
 <mickael.salaun@ssi.gouv.fr>,
        Philippe =?ISO-8859-1?Q?Tr=E9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean
 Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan
 <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
        Steve Grubb
 <sgrubb@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        "kernel-hardening@lists.openwall.com"
 <kernel-hardening@lists.openwall.com>,
        "linux-api@vger.kernel.org"
 <linux-api@vger.kernel.org>,
        "linux-integrity@vger.kernel.org"
 <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>
Date: Fri, 08 May 2020 10:01:07 -0400
In-Reply-To: <CAP22eLFmNkeQNbmQ_SAbnrDUnv2W-zYJ+ijnE22C3ph2vUiQiQ@mail.gmail.com>
References: <20200505153156.925111-1-mic@digikod.net>
	 <20b24b9ca0a64afb9389722845738ec8@AcuMS.aculab.com>
	 <907109c8-9b19-528a-726f-92c3f61c1563@digikod.net>
	 <ad28ab5fe7854b41a575656e95b4da17@AcuMS.aculab.com>
	 <64426377-7fc4-6f37-7371-2e2a584e3032@digikod.net>
	 <635df0655b644408ac4822def8900383@AcuMS.aculab.com>
	 <1ced6f5f-7181-1dc5-2da7-abf4abd5ad23@digikod.net>
	 <CAP22eLFmNkeQNbmQ_SAbnrDUnv2W-zYJ+ijnE22C3ph2vUiQiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_13:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=932
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 clxscore=1011
 adultscore=0 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080116

On Fri, 2020-05-08 at 10:15 +0300, Lev R. Oshvang . wrote:

> I can suggest something better ( I believe)
> Some time ago I proposed patch to IMA -  Add suffix in IMA policy rule criteria
> It allows IMA to verify scripts, configuration files and even single file.
> It is very simple and does not depend on open flags.
> Mimi Zohar decided not to include this patch on the reason it tries to
> protect the file name.
> ( Why ??).

Your patch relies on the filename, but does nothing to protect it. 

Mimi
