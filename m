Return-Path: <SRS0=ZBsH=E3=lists.openwall.com=kernel-hardening-return-20450-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E692DC388F9
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 10:06:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0F8822145D
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 10:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F8822145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20450-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32532 invoked by uid 550); 21 Nov 2020 10:06:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32497 invoked from network); 21 Nov 2020 10:06:18 -0000
Subject: Re: [PATCH v24 07/12] landlock: Support filesystem access-control
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
References: <20201112205141.775752-1-mic@digikod.net>
 <20201112205141.775752-8-mic@digikod.net>
 <CAG48ez3HA63CX852LLDFCcNyzRGwAr3x_cvA1-t8tgDxfF1dOQ@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <1d524ea9-85eb-049c-2156-05cad6d6fcfd@digikod.net>
Date: Sat, 21 Nov 2020 11:06:05 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez3HA63CX852LLDFCcNyzRGwAr3x_cvA1-t8tgDxfF1dOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 21/11/2020 08:00, Jann Horn wrote:
> On Thu, Nov 12, 2020 at 9:52 PM Mickaël Salaün <mic@digikod.net> wrote:
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
>>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Jeff Dike <jdike@addtoit.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Richard Weinberger <richard@nod.at>
>> Cc: Serge E. Hallyn <serge@hallyn.com>
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
>> ---
>>
>> Changes since v23:
>> * Enforce deterministic interleaved path rules.  To have consistent
>>   layered rules, granting access to a path implies that all accesses
>>   tied to inodes, from the requested file to the real root, must be
>>   checked.  Otherwise, stacked rules may result to overzealous
>>   restrictions.  By excluding the ability to add exceptions in the same
>>   layer (e.g. /a allowed, /a/b denied, and /a/b/c allowed), we get
>>   deterministic interleaved path rules.  This removes an optimization
> 
> I don't understand the "deterministic interleaved path rules" part.

I explain bellow.

> 
> 
> What if I have a policy like this?
> 
> /home/user READ
> /home/user/Downloads READ+WRITE
> 
> That's a reasonable policy, right?

Definitely, I forgot this, thanks for the outside perspective!

> 
> If I then try to open /home/user/Downloads/foo in WRITE mode, the loop
> will first check against the READ+WRITE rule for /home/user, that
> check will pass, and then it will check against the READ rule for /,
> which will deny the access, right? That seems bad.

Yes that was the intent.

> 
> 
> The v22 code ensured that for each layer, the most specific rule (the
> first we encounter on the walk) always wins, right? What's the problem
> with that?

This can be explained with the interleaved_masked_accesses test:
https://github.com/landlock-lsm/linux/blob/landlock-v24/tools/testing/selftests/landlock/fs_test.c#L647

In this case there is 4 stacked layers:
layer 1: allows s1d1/s1d2/s1d3/file1
layer 2: allows s1d1/s1d2/s1d3
         denies s1d1/s1d2
layer 3: allows s1d1
layer 4: allows s1d1/s1d2

In the v23, access to file1 would be allowed until layer 3, but layer 4
would merge a new rule for the s1d2 inode. Because we don't record where
exactly the access come from, we can't tell that layer 2 allowed access
thanks to s1d3 and that its s1d2 rule was ignored. I think this behavior
doesn't make sense from the user point of view.

In the v24, access to file1 would only be allowed with layer 1. The
layer 2, would deny access to file1 because of the s1d2 rule. This makes
the reasoning consistent and deterministic whatever the layers are,
while storing the same access and layer bits. But I agree that this may
not be desirable.

In a perfect v25, file1 should be allowed by all these layers. I didn't
find a simple solution to this while minimizing the memory allocated by
rule (cf. struct landlock_rule: mainly 32-bits for access rights and
64-bits for the layers that contributed to this ANDed accesses). I would
like to avoid storing 32-bits access rights per stacked layer. Do you
see another solution?

> 
>>   which could be replaced by a proper cache mechanism.  This also
>>   further simplifies and explain check_access_path_continue().
> 
>>From the interdiff between v23 and v24 (git range-diff
> 99ade5d59b23~1..99ade5d59b23 faa8c09be9fd~1..faa8c09be9fd):
> 
>     @@ security/landlock/fs.c (new)
>      +                  rcu_dereference(landlock_inode(inode)->object));
>      +  rcu_read_unlock();
>      +
>     -+  /* Checks for matching layers. */
>     -+  if (rule && (rule->layers | *layer_mask)) {
>     -+          if ((rule->access & access_request) == access_request) {
>     -+                  *layer_mask &= ~rule->layers;
>     -+                  return true;
>     -+          } else {
>     -+                  return false;
>     -+          }
>     ++  if (!rule)
>     ++          /* Continues to walk if there is no rule for this inode. */
>     ++          return true;
>     ++  /*
>     ++   * We must check all layers for each inode because we may encounter
>     ++   * multiple different accesses from the same layer in a walk.  Each
>     ++   * layer must at least allow the access request one time (i.e. with one
>     ++   * inode).  This enables to have a deterministic behavior whatever
>     ++   * inode is tagged within interleaved layers.
>     ++   */
>     ++  if ((rule->access & access_request) == access_request) {
>     ++          /* Validates layers for which all accesses are allowed. */
>     ++          *layer_mask &= ~rule->layers;
>     ++          /* Continues to walk until all layers are validated. */
>     ++          return true;
>      +  }
>     -+  return true;
>     ++  /* Stops if a rule in the path don't allow all requested access. */
>     ++  return false;
>      +}
>      +
>      +static int check_access_path(const struct landlock_ruleset *const domain,
>     @@ security/landlock/fs.c (new)
>      +                          &layer_mask)) {
>      +          struct dentry *parent_dentry;
>      +
>     -+          /* Stops when a rule from each layer granted access. */
>     -+          if (layer_mask == 0) {
>     -+                  allowed = true;
>     -+                  break;
>     -+          }
>     -+
> 
> This change also made it so that disconnected paths aren't accessible
> unless they're internal, right? While previously, the access could be
> permitted if the walk stops before reaching the disconnected point? I
> guess that's fine, but it should probably be documented.

Right, I should add a test for this case anyway.

> 
>      +jump_up:
>      +          /*
>      +           * Does not work with orphaned/private mounts like overlayfs
>     @@ security/landlock/fs.c (new)
>      +                          goto jump_up;
>      +                  } else {
>      +                          /*
>     -+                           * Stops at the real root.  Denies access
>     -+                           * because not all layers have granted access.
>     ++                           * Stops at the real root.  Denies access if
>     ++                           * not all layers granted access.
>      +                           */
>     -+                          allowed = false;
>     ++                          allowed = (layer_mask == 0);
>      +                          break;
>      +                  }
>      +          }
> 
