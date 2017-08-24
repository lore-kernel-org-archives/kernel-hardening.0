Date: Wed, 23 Aug 2017 18:22:07 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Message-ID: <20170824012206.3ymlecfhyh5ztshk@ast-mbp>
References: <20170821000933.13024-1-mic@digikod.net>
 <20170821000933.13024-3-mic@digikod.net>
 <20170823024452.zvizovwfd7xjucsx@ast-mbp>
 <607ceb21-5aa5-678b-4438-0d8dcb69fc3c@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <607ceb21-5aa5-678b-4438-0d8dcb69fc3c@digikod.net>
Subject: [kernel-hardening] Re: [PATCH net-next v7 02/10] bpf: Add eBPF program subtype and
 is_valid_subtype() verifier
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Matthew Garrett <mjg59@srcf.ucam.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 23, 2017 at 09:45:24AM +0200, Mickaël Salaün wrote:
> >>  
> >> +union bpf_prog_subtype {
> >> +	struct {
> >> +		__u32		abi; /* minimal ABI version, cf. user doc */
> > 
> > the concept of abi (version) sounds a bit weird to me.
> > Why bother with it at all?
> > Once the first set of patches lands the kernel as whole will have landlock feature
> > with a set of helpers, actions, event types.
> > Some future patches will extend the landlock feature step by step.
> > This abi concept assumes that anyone who adds new helper would need
> > to keep incrementing this 'abi'. What value does it give to user or to kernel?
> > The users will already know that landlock is present in kernel 4.14 or whatever
> > and the kernel 4.18 has more landlock features. Why bother with extra abi number?
> 
> That's right for helpers and context fields, but we can't check the use
> of one field's content. The status field is intended to be a bitfield
> extendable in the future. For example, one use case is to set a flag to
> inform the eBPF program that it was already called with the same context
> and can skip most of its check (if not related to maps). Same goes for

'status' field ? I don't see it in the current patch set.
You mean something like scratch space in landlock_ctx that
program can write to? Sure, that's a good extension.

> the FS action bitfield, one may want to add more of them. Another
> example may be the check for abilities. We may want to relax/remove the
> capability require to set one of them. With an ABI version, the user can
> easily check if the current kernel support that.

sure. there will be future extensions. I still fail to see
why 'abi' field is needed.
Also consider that bpf core itself is being extended all the time as well.
The verifier gets smarter and smarter, so the programs deemed unsafe
a year ago now recognized properly by the verifier.
New instructions being added to the core and so on.
That means that newer landlock programs will not be acceptable by
older kernels. We cannot increment abi/version with every such change.
It's also possible that in the future we may catch a security bug
in the verifier that will start rejecting some corner case of the programs.
The only way to use landlock is to develop a set of programs/rules
for kernel version X and we together will guarantee that these programs
will work fine in the future kernels.
There is a good chance that the rules developed for kernel X+1 will _not_
be loadable on older kernel X even if you don't change anything on
landlock side (helpers, actions, events), so landlock abi/version will
stay the same but you won't get the effect you're looking to get from
this abi concept. Since landlock abi=1 in kernel X and abi=1 in kernel X+1
doesn't mean that landlock rules developed for X+1 will work on X.
Beyond bpf core there are other moving pieces. LSM may get new hooks,
seccomp side will be changed, etc. Incrementing landlock abi is not pracitcal.
