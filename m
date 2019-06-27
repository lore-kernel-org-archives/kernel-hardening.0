Return-Path: <SRS0=AyYh=U2=lists.openwall.com=kernel-hardening-return-16299-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9890EC48BD7
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 16:58:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E979B2146E
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 16:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E979B2146E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16299-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1195 invoked by uid 550); 27 Jun 2019 16:58:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1163 invoked from network); 27 Jun 2019 16:58:16 -0000
Date: Thu, 27 Jun 2019 17:56:40 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Drysdale <drysdale@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
	Tejun Heo <tj@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
	Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 05/10] bpf,landlock: Add a new map type: inode
Message-ID: <20190627165640.GQ17978@ZenIV.linux.org.uk>
References: <20190625215239.11136-1-mic@digikod.net>
 <20190625215239.11136-6-mic@digikod.net>
 <20190625225201.GJ17978@ZenIV.linux.org.uk>
 <79bac827-4092-8a4d-9dc6-6019419b2486@ssi.gouv.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79bac827-4092-8a4d-9dc6-6019419b2486@ssi.gouv.fr>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: Al Viro <viro@ftp.linux.org.uk>

On Thu, Jun 27, 2019 at 06:18:12PM +0200, Mickaël Salaün wrote:

> >> +/* called from syscall */
> >> +static int sys_inode_map_delete_elem(struct bpf_map *map, struct inode *key)
> >> +{
> >> +    struct inode_array *array = container_of(map, struct inode_array, map);
> >> +    struct inode *inode;
> >> +    int i;
> >> +
> >> +    WARN_ON_ONCE(!rcu_read_lock_held());
> >> +    for (i = 0; i < array->map.max_entries; i++) {
> >> +            if (array->elems[i].inode == key) {
> >> +                    inode = xchg(&array->elems[i].inode, NULL);
> >> +                    array->nb_entries--;
> >
> > Umm...  Is that intended to be atomic in any sense?
> 
> nb_entries is not used as a bound check but to avoid walking uselessly
> through the (pre-allocated) array when adding a new element, but I'll
> use an atomic to avoid inconsistencies anyway.


> > Wait a sec...  So we have those beasties that can have long-term
> > references to arbitrary inodes stuck in them?  What will happen
> > if you get umount(2) called while such a thing exists?
> 
> I though an umount would be denied but no, we get a self-destructed busy
> inode and a bug!
> What about wrapping the inode's superblock->s_op->destroy_inode() to
> first remove the element from the map and then call the real
> destroy_inode(), if any?

What do you mean, _the_ map?  I don't see anything to prevent insertion
of references to the same inode into any number of those...

> Or I could update fs/inode.c:destroy_inode() to call inode->free_inode()
> if it is set, and set it when such inode is referenced by a map?
> Or maybe I could hold the referencing file in the map and then wrap its
> f_op?

First of all, anything including the word "wrap" is a non-starter.
We really don't need the headache associated with the locking needed
to replace the method tables on the fly, or with the code checking that
->f_op points to given method table, etc.  That's not going to fly,
especially since you'd end up _chaining_ those (again, the same reference
can go in more than once).

Nothing is allowed to change the method tables of live objects, period.
Once a struct file is opened, its ->f_op is never going to change and
it entirely belongs to the device driver or filesystem it resides on.
Nothing else (not VFS, not VM, not some LSM module, etc.) has any business
touching that.  The same goes for inodes, dentries, etc.

What kind of behaviour do you want there?  Do you want the inodes you've
referenced there to be forgotten on e.g. memory pressure?  The thing is,
I don't see how "it's getting freed" could map onto any semantics that
might be useful for you - it looks like the wrong event for that.
