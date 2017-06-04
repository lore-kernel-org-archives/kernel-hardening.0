References: <20170603055351.16080-1-matt@nmatt.com>
 <20170603063354.GJ6365@ZenIV.linux.org.uk>
From: Matt Brown <matt@nmatt.com>
Message-ID: <a507374a-e1b9-de56-5d50-825c283111ca@nmatt.com>
Date: Sun, 4 Jun 2017 01:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <20170603063354.GJ6365@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 1/1] Add Trusted Path Execution as a stackable LSM
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: james.l.morris@oracle.com, serge@hallyn.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/03/2017 02:33 AM, Al Viro wrote:
> On Sat, Jun 03, 2017 at 01:53:51AM -0400, Matt Brown wrote:
>
>> +static int tpe_bprm_set_creds(struct linux_binprm *bprm)
>> +{
>> +	struct file *file = bprm->file;
>> +	struct inode *inode = d_backing_inode(file->f_path.dentry->d_parent);
>> +	struct inode *file_inode = d_backing_inode(file->f_path.dentry);
>
> Bloody wonderful.  Do tell, what *does* prevent a race with rename(2) here,
> somehow making sure that your 'inode' won't get freed right under you?
>

Good catch. How does this look:

spin_lock(&inode->i_lock);
spin_lock(&file_inode->i_lock);
if (global_nonroot(inode->i_uid) && !uid_eq(inode->i_uid, cred->uid))
	reason1 = "directory not owned by user";
else if (inode->i_mode & 0002)
	reason1 = "file in world-writable directory";
else if ((inode->i_mode & 0020) && global_nonroot_gid(inode->i_gid))
	reason1 = "file in group-writable directory";
else if (file_inode->i_mode & 0002)
	reason1 = "file is world-writable";
spin_unlock(&inode->i_lock);
spin_unlock(&file_inode->i_lock);

and likewise for other places in the code?
