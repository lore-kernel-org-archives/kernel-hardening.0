Date: Sat, 3 Jun 2017 07:33:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20170603063354.GJ6365@ZenIV.linux.org.uk>
References: <20170603055351.16080-1-matt@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170603055351.16080-1-matt@nmatt.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v1 1/1] Add Trusted Path Execution as a stackable LSM
To: Matt Brown <matt@nmatt.com>
Cc: james.l.morris@oracle.com, serge@hallyn.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 03, 2017 at 01:53:51AM -0400, Matt Brown wrote:

> +static int tpe_bprm_set_creds(struct linux_binprm *bprm)
> +{
> +	struct file *file = bprm->file;
> +	struct inode *inode = d_backing_inode(file->f_path.dentry->d_parent);
> +	struct inode *file_inode = d_backing_inode(file->f_path.dentry);

Bloody wonderful.  Do tell, what *does* prevent a race with rename(2) here,
somehow making sure that your 'inode' won't get freed right under you?
