From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Thu, 13 Jul 2017 11:19:39 -0400
In-Reply-To: <988555a2-bed9-234c-843c-0bb68dc60d3f@nmatt.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
	 <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net>
	 <CAJHCu1+=uYQ-N7CH4KfmTHrN2hJjwzN0tgg4sWHU0LjVr+uGGA@mail.gmail.com>
	 <c19917fa-f62c-b7e0-8cbd-f10a96f686ba@digikod.net>
	 <CAJHCu1K1Hg5M2HhJxN_aj2P_S8Pez9+8KL=wHKBgAN0jN1+mLg@mail.gmail.com>
	 <69ff2195-d0e1-8a0f-b80e-5d8d55947907@nmatt.com>
	 <1499801476.6034.265.camel@linux.vnet.ibm.com>
	 <988555a2-bed9-234c-843c-0bb68dc60d3f@nmatt.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1499959179.4220.45.camel@linux.vnet.ibm.com>
Subject: Re: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
To: Matt Brown <matt@nmatt.com>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-07-13 at 08:39 -0400, Matt Brown wrote:
> On 7/11/17 3:31 PM, Mimi Zohar wrote:
> > On Tue, 2017-07-11 at 13:49 -0400, Matt Brown wrote:
> > 
> >> I have merged my TPE LSM with Mimi Zohar's shebang LSM and will be
> >> releasing a version 3 soon. I have also added securityfs support to
> >> shebang that will allow users to update the interpreter list at run
> >> time. This allows for user's to configure TPE/Shebang without any
> >> xattrs. For a preview of my version 3 you can check out my dev tree
> >> here:
> >> https://github.com/nmatt0/linux-security/tree/tpe/security/tpe
> >>
> >> Note: that git tree is WIP and may not have all of the attribution and
> >> documentation needed.
> > 
> > You'll want to detect when an interpreter is deleted or renamed.  I
> > would define security_inode_rename, security_path_rename,
> > security_inode_unlink and security_path_unlink hooks.
> > 
> > "rename" could be an indication that the existing interpreter is being
> > updated. "unlink" indicates that the interpreter has been deleted.  At
> > either of these points, you'll want to start checking for the creation
> > of a new file with the expected pathname.
> > 
> > Mimi
> > 
> 
> Would it be better just to check for paths rather than inodes?

Below is a simple example on my laptop of the same inode with
different path names.  In this case, a list of pathnames would be
double the number of inodes.  I'm not sure from a performance
perspective if this really matters, or if doing string compares
matters.  We're not talking about thousands or even hundreds of files,
though this is on the LSM bprm check hook.

The question is really from a security perspective which is better?
 Obviously, as v2 of the patch set changed from using pathnames to
inodes, it's pretty clear that I think inodes would be better.  Kees,
Serge, Casey any comments?

example:
$ rpm -qf /usr/bin/bash
bash-4.3.42-7.fc24.x86_64

$ rpm -q --dump bash | grep \/bin\/bash
/usr/bin/bash 1071984 1475233750
84c7d10de5f9c729f9d60e95bc97197a5e029a14e07820bc45ad309da91703f9
0100755 root root 0 0 0 X
/usr/bin/bashbug 10 1475233749
0000000000000000000000000000000000000000000000000000000000000000
0120777 root root 0 0 0 bashbug-64
/usr/bin/bashbug-64 7110 1475233745
0dd706d221569a7966f0246fcb40dd7f3bff4550c4ad0ee70ae8b0c6bc350157
0100755 root root 0 0 0 X

$ stat /bin/bash
  File: '/bin/bash'
  Size: 1071984   	Blocks: 2104       IO Block: 4096   regular
file
Device: 804h/2052d	Inode: 1180420     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid:
(    0/    root)
Context: system_u:object_r:shell_exec_t:s0
Access: 2017-07-12 21:56:28.125594261 -0400
Modify: 2016-09-30 07:09:10.000000000 -0400
Change: 2017-01-25 10:10:18.784719749 -0500
 Birth: -

$ stat /usr/bin/bash
  File: '/usr/bin/bash'
  Size: 1071984   	Blocks: 2104       IO Block: 4096   regular
file
Device: 804h/2052d	Inode: 1180420     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid:
(    0/    root)
Context: system_u:object_r:shell_exec_t:s0
Access: 2017-07-12 21:56:28.125594261 -0400
Modify: 2016-09-30 07:09:10.000000000 -0400
Change: 2017-01-25 10:10:18.784719749 -0500
 Birth: -

$ ls -lat / | grep bin
lrwxrwxrwx.   1 root root     7 Feb  3  2016 bin -> usr/bin
lrwxrwxrwx.   1 root root     8 Feb  3  2016 sbin -> usr/sbin

Mimi
