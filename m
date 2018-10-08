Date: Sun, 7 Oct 2018 19:22:11 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: introduce BPF_PROG_TYPE_FILE_FILTER
Message-ID: <20181008022210.33ljgryhodzunf5l@ast-mbp>
References: <20181004025750.498303-1-ast@kernel.org>
 <20181004025750.498303-2-ast@kernel.org>
 <CAG48ez2zuJP0qOSU5QAER1xP56d5SvC0HTrM0Yh3wkKEQZ9R3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez2zuJP0qOSU5QAER1xP56d5SvC0HTrM0Yh3wkKEQZ9R3A@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Network Development <netdev@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 08, 2018 at 02:56:15AM +0200, Jann Horn wrote:
> +cc kernel-hardening because this is related to sandboxing
> +cc Mickaël Salaün because this looks related to his Landlock proposal

It may seem that this work overlaps with landlock, but the goals
are different. Landlock is LSM based to act as _security_ framework
with end goal being available to unpriv users.
While this cgroup-bpf hook is expected to stay root only,
since we're trying to restrict what containers can do in a trusted environment.
'sandboxing' is overloaded word.
Sandboxing for security and sandboxing of trusted root are different.

> On Mon, Oct 8, 2018 at 2:30 AM Alexei Starovoitov <ast@kernel.org> wrote:
> > Similar to networking sandboxing programs and cgroup-v2 based hooks
> > (BPF_CGROUP_INET_[INGRESS|EGRESS,] BPF_CGROUP_INET[4|6]_[BIND|CONNECT], etc)
> > introduce basic per-container sandboxing for file access via
> > new BPF_PROG_TYPE_FILE_FILTER program type that attaches after
> > security_file_open() LSM hook and works as additional file_open filter.
> > The new cgroup bpf hook is called BPF_CGROUP_FILE_OPEN.
> 
> Why do_dentry_open() specifically, and nothing else? If you want to
> filter open, wouldn't you also want to filter a bunch of other
> filesystem operations with LSM hooks, like rename, unlink, truncate
> and so on? Landlock benefits there from re-using the existing security
> hooks.

It may make sense to extend in the future, but we don't have clear
user cases for rename/unlink/truncate at this point.

As you can see the amount of pushback even for basic file access is high.
Hence I don't think the landlock can be upstreamed in the current form,
since it touches VFS layer a lot more than this patch.
It's intrusive to LSM, and adds new concepts to BPF as well.
This work fits into existing BPF machinery and minimally intrusive to VFS.
I hope we can find a common ground with Al regarding what file
access primitives are exposed to BPF side.
Once we agree on that the landlock can piggy back on this work
and extend it to all file-based LSM hooks.
The first step for everyone interested in bpf-based 'sandboxing'
is to figure out VFS<->BPF interface.
If you or Mickael have suggestions on what bpf progs should and should not
see at these hooks, it's a good time to discuss.
I believe the fields proposed are the obvious minimum.

> > Just like other cgroup-bpf programs new BPF_PROG_TYPE_FILE_FILTER type
> > is only available to root.
> >
> > This program type has access to single argument 'struct bpf_file_info'
> > that contains standard sys_stat fields:
> > struct bpf_file_info {
> >         __u64 inode;
> >         __u32 dev_major;
> >         __u32 dev_minor;
> >         __u32 fs_magic;
> >         __u32 mnt_id;
> >         __u32 nlink;
> >         __u32 mode;     /* file mode S_ISDIR, S_ISLNK, 0755, etc */
> >         __u32 flags;    /* open flags O_RDWR, O_CREAT, etc */
> > };
> > Other file attributes can be added in the future to the end of this struct
> > without breaking bpf programs.
> >
> > For debugging introduce bpf_get_file_path() helper that returns
> > NUL-terminated full path of the file. It should never be used for sandboxing.
> >
> > Use cases:
> > - disallow certain FS types within containers (fs_magic == CGROUP2_SUPER_MAGIC)
> > - restrict permissions in particular mount (mnt_id == X && (flags & O_RDWR))
> > - disallow access to hard linked sensitive files (nlink > 1 && mode == 0700)
> > - disallow access to world writeable files (mode == 0..7)
> > - disallow access to given set of files (dev_major == X && dev_minor == Y && inode == Z)
> 
> That last one sounds weird. It doesn't work if you want to ban access
> to a whole directory at once. And in general, highly specific
> blocklists make me nervous, because if you add anything new and forget
> to put it on the list, you have a problem.

In the upcoming V2 of the patches the direct exposure to dev and inode will be removed.
And instead the opaque 'struct file_handle' will be available to bpf progs.
The use case is indeed to restrict access to specific blacklist of files.
The user space will collect the set of files via sys_name_to_handle_at(),
then store the fhandles in bpf map, and bpf prog will consult the map
to deny the access.
It's not a replacement for ACLs, directory permissions, etc. The use case
is to prevent trusted containers messing up the environment.
The continuous integration system needs to run some containers (and tests inside them)
with root privs. When these jobs mess up the system the subsequent jobs may incorrectly
fail. We believe that this cgroup based container enforcement will solve this use case
and similar other use cases when containers are trusted, but could be buggy when
it comes to file access.

To recap what I'm implementing in V2:
1.
struct bpf_file_info {
        __u32 fs_magic; // file->f_inode->i_sb->s_magic
        __u32 mnt_id;   // real_mount(file->f_path.mnt)->mnt_id
        __u32 nlink;    // file->f_inode->i_nlink
        __u32 mode;     // file->f_inode->i_mode
        __u32 flags;    // file->f_flags
};
I double checked what VFS layer does with above fields and I think
there is no additional user space exposure will be made when such
fields are seen by bpf progs.
But since I'm not a VFS expert, I'd like Al to confirm.

2.
bpf_get_file_handle(struct bpf_file_info *ctx, struct file_handle *fh, int fh_size);
helper that bpf prog will use to obtain fh of the file about to be open.

3.
bpf_get_file_statx(struct bpf_file_info *ctx, struct statx *sx, int size, int flags);
Though struct statx is 256 bytes, and the helper would have to touch all bytes
I couldn't figure out the faster way to get to inode/dev/uid of the given file
that will work on all underlying FSes.

Thoughts?
