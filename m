Return-Path: <SRS0=iNV2=GR=lists.openwall.com=kernel-hardening-return-20645-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B376C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 18:55:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2DCD523B31
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 18:55:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DCD523B31
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20645-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3668 invoked by uid 550); 14 Jan 2021 18:55:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3636 invoked from network); 14 Jan 2021 18:55:00 -0000
Subject: Re: [PATCH v26 07/12] landlock: Support filesystem access-control
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20201209192839.1396820-1-mic@digikod.net>
 <20201209192839.1396820-8-mic@digikod.net>
 <CAG48ez1wbAQwU-eoC9DngHyUM_5F01MJQpRnLaJFvfRUrnXBdA@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <aeb3e152-8108-89d2-0577-4b130368f14f@digikod.net>
Date: Thu, 14 Jan 2021 19:54:36 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez1wbAQwU-eoC9DngHyUM_5F01MJQpRnLaJFvfRUrnXBdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 14/01/2021 04:22, Jann Horn wrote:
> On Wed, Dec 9, 2020 at 8:28 PM Mickaël Salaün <mic@digikod.net> wrote:
>> Thanks to the Landlock objects and ruleset, it is possible to identify
>> inodes according to a process's domain.  To enable an unprivileged
>> process to express a file hierarchy, it first needs to open a directory
>> (or a file) and pass this file descriptor to the kernel through
>> landlock_add_rule(2).  When checking if a file access request is
>> allowed, we walk from the requested dentry to the real root, following
>> the different mount layers.  The access to each "tagged" inodes are
>> collected according to their rule layer level, and ANDed to create
>> access to the requested file hierarchy.  This makes possible to identify
>> a lot of files without tagging every inodes nor modifying the
>> filesystem, while still following the view and understanding the user
>> has from the filesystem.
>>
>> Add a new ARCH_EPHEMERAL_INODES for UML because it currently does not
>> keep the same struct inodes for the same inodes whereas these inodes are
>> in use.
>>
>> This commit adds a minimal set of supported filesystem access-control
>> which doesn't enable to restrict all file-related actions.  This is the
>> result of multiple discussions to minimize the code of Landlock to ease
>> review.  Thanks to the Landlock design, extending this access-control
>> without breaking user space will not be a problem.  Moreover, seccomp
>> filters can be used to restrict the use of syscall families which may
>> not be currently handled by Landlock.
> [...]
>> +static bool check_access_path_continue(
>> +               const struct landlock_ruleset *const domain,
>> +               const struct path *const path, const u32 access_request,
>> +               u64 *const layer_mask)
>> +{
> [...]
>> +       /*
>> +        * An access is granted if, for each policy layer, at least one rule
>> +        * encountered on the pathwalk grants the access, regardless of their
>> +        * position in the layer stack.  We must then check not-yet-seen layers
>> +        * for each inode, from the last one added to the first one.
>> +        */
>> +       for (i = 0; i < rule->num_layers; i++) {
>> +               const struct landlock_layer *const layer = &rule->layers[i];
>> +               const u64 layer_level = BIT_ULL(layer->level - 1);
>> +
>> +               if (!(layer_level & *layer_mask))
>> +                       continue;
>> +               if ((layer->access & access_request) != access_request)
>> +                       return false;
>> +               *layer_mask &= ~layer_level;
> 
> Hmm... shouldn't the last 5 lines be replaced by the following?
> 
> if ((layer->access & access_request) == access_request)
>     *layer_mask &= ~layer_level;
> 
> And then, since this function would always return true, you could
> change its return type to "void".
> 
> 
> As far as I can tell, the current version will still, if a ruleset
> looks like this:
> 
> /usr read+write
> /usr/lib/ read
> 
> reject write access to /usr/lib, right?

If these two rules are from different layers, then yes it would work as
intended. However, if these rules are from the same layer the path walk
will not stop at /usr/lib but go down to /usr, which grants write
access. This is the reason I wrote it like this and the
layout1.inherit_subset test checks that. I'm updating the documentation
to better explain how an access is checked with one or multiple layers.

Doing this way also enables to stop the path walk earlier, which is the
original purpose of this function.


> 
> 
>> +       }
>> +       return true;
>> +}
