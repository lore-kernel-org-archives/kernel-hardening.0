References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608034349.31876-2-matt@nmatt.com> <20170608130547.GA22981@openwall.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <6de4f9c0-691e-d7ac-5d08-e1433b0c8bd5@nmatt.com>
Date: Thu, 8 Jun 2017 09:16:27 -0400
MIME-Version: 1.0
In-Reply-To: <20170608130547.GA22981@openwall.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v2 1/1] Add Trusted Path Execution as a
 stackable LSM
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/8/17 9:05 AM, Solar Designer wrote:
> Matt,
> 
> I really didn't intend to comment on this further, but I just happened
> to notice:
> 
> On Wed, Jun 07, 2017 at 11:43:49PM -0400, Matt Brown wrote:
>> +static int tpe_check(struct file *file, char *method)
>> +{
>> +	struct inode *inode;
>> +	struct inode *file_inode;
>> +	struct dentry *dir;
>> +	const struct cred *cred = current_cred();
>> +	char *reason1 = NULL;
>> +	char *reason2 = NULL;
>> +
>> +	dir = dget_parent(file->f_path.dentry);
>> +	inode = d_backing_inode(dir);
>> +	file_inode = d_backing_inode(file->f_path.dentry);
>> +
>> +	if (!tpe_enabled)
>> +		return 0;
> 
> You have many return statements in tpe_check(), where it is already past
> dget_parent() and thus must have reached:
> 

crap, you're right. Will fix this in v3.

>> +end:
>> +	dput(dir);
> 
> You'll probably want to move the dget_parent() and the following two
> lines to be below the first few checks where you may just return, and
> then be careful not to ever use a return statement anymore.
> 
> Alexander
> 
