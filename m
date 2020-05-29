Return-Path: <SRS0=W3Hx=7L=lists.openwall.com=kernel-hardening-return-18892-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D60C433E1
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 May 2020 11:29:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D2F302074D
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 May 2020 11:29:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2F302074D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18892-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16003 invoked by uid 550); 29 May 2020 11:29:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15969 invoked from network); 29 May 2020 11:29:37 -0000
Subject: Re: [PATCH v18 07/12] landlock: Support filesystem access-control
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, Linux API <linux-api@vger.kernel.org>,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-kselftest@vger.kernel.org,
 LSM List <linux-security-module@vger.kernel.org>, x86@kernel.org
References: <20200526205322.23465-1-mic@digikod.net>
 <20200526205322.23465-8-mic@digikod.net>
 <CAOQ4uxibpDTyjCJWLGG9jr-Gv9PwO==o50b9O8HGQeUfVMDFag@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <8e76c2ed-1725-f0a5-bcfc-317c4277af3b@digikod.net>
Date: Fri, 29 May 2020 13:29:20 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxibpDTyjCJWLGG9jr-Gv9PwO==o50b9O8HGQeUfVMDFag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 27/05/2020 05:07, Amir Goldstein wrote:
> On Wed, May 27, 2020 at 3:36 AM Mickaël Salaün <mic@digikod.net> wrote:
>>
>> Thanks to the Landlock objects and ruleset, it is possible to identify
>> inodes according to a process's domain.  To enable an unprivileged
>> process to express a file hierarchy, it first needs to open a directory
>> (or a file) and pass this file descriptor to the kernel through
>> landlock(2).  When checking if a file access request is allowed, we walk
>> from the requested dentry to the real root, following the different
>> mount layers.  The access to each "tagged" inodes are collected
>> according to their rule layer level, and ANDed to create access to the
>> requested file hierarchy.  This makes possible to identify a lot of
>> files without tagging every inodes nor modifying the filesystem, while
>> still following the view and understanding the user has from the
>> filesystem.
>>
> 
> Hi Mickael,
> 
> Nice work! I am interested in the problem of system wide file access
> rules based on directory hierarchy [1][2]. Not the same problem, but
> with obvious overlaps.

Interesting. Landlock's goal is to restrict a set of processes, which
can be a container.

> 
> I sketched this untested POC [2] a while ago -
> It introduces the concept of "border control" LSM hooks to avoid the
> need to check which sections in the hierarchy an inode belongs to
> on every syscall.
> 
> With this, you could cache a topology with id's per section and
> cache the section id + topology generation in the inode's security state.
> When inode crosses border control hooks, it's section id is updated.
> When directory hierarchy topology changes, some or all of the cached
> section id's are invalidated and rules <-> sections relations may need
> to be changed.
> 
> Do you think something like that could be useful for landlock?

Because Landlock deals with unprivileged sandboxing, we must manage
multiple layers. The current implementation in Landlock, according to
the unprivileged constraints, is explained here:
https://lore.kernel.org/lkml/e07fe473-1801-01cc-12ae-b3167f95250e@digikod.net/

As briefly explained in this patch [1] [2], in the case of Landlock,
being able to change the filesystem layout/topology may lead to
privilege escalation. Currently, Landlock forbids inode reparenting, but
I plan to implement a multilayer partial ordering mechanism to relax
this constraint while still enforcing all layered policies. A short-term
approach could also relaxes the first layer, but we need to think
carefully about the potential implications (including ABI compatibility).

[1]
https://github.com/landlock-lsm/linux/commit/b670df6c5add5cf96870327871c35fccb97a0dd8#diff-39adb7412180a73fe7c6b91ae5435a5bR354
(must clic on "Load diff")
[2]
https://github.com/landlock-lsm/linux/commit/b670df6c5add5cf96870327871c35fccb97a0dd8#diff-39adb7412180a73fe7c6b91ae5435a5bR450
(must clic on "Load diff")

I think Landlock could help in your use case, but could you clarify your
thread model please?

The main issue right now with Landlock is to deal with overlayfs.
Indeed, Landlock's check_access_path() does not work with
orphaned/private mounts like overlayfs layers (cf. ovl_path_real() and
ovl_path_open()). Do you have an idea how to solve this properly? Could
we add a "virtual" mount point to these layers to identify dentries they
are anchored to?

> 
> Note that the POC is using d_mountpoint() as the only type of "fence"
> mark. It is sufficient for controlling rename in and out of containers, so
> I just used an already available dentry flag for "fence".
> If the border control hook concept is useful, this could be extended to
> a more generic d_border_passing(), with some internal kernel API
> to manage it and with all the bike shedding that comes with it...

Why not just compare struct path->mnt using the current hooks?

About performances, I also thought that walking through every path
directories would be an important issue, but after some quick benchmark
(with and for Landlock) I'm not sure anymore. A caching mechanism may be
useful but it should not be needed from the start.

> 
> Thanks,
> Amir.

I would like to be in Cc in your next "fanotify and LSM path hooks"
emails. Thanks.

> 
> [1] https://lore.kernel.org/linux-fsdevel/CAOQ4uxhBVhyyJv0+xSFQiGQEj60AbD3SADfKK40uAiC4GF2p9Q@mail.gmail.com/
> [2] https://lore.kernel.org/linux-fsdevel/CAOQ4uxgn=YNj8cJuccx2KqxEVGZy1z3DBVYXrD=Mc7Dc=Je+-w@mail.gmail.com/
> [3] https://github.com/amir73il/linux/commits/rename_xmnt
> 
