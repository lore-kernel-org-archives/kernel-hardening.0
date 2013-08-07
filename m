Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <52026F38.60301@schaufler-ca.com>
Date: Wed, 07 Aug 2013 09:00:56 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
MIME-Version: 1.0
References: <201308031715.FCH73469.OVOHQStOFMLJFF@I-love.SAKURA.ne.jp> <20130807143151.GA4560@cachalot>
In-Reply-To: <20130807143151.GA4560@cachalot>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] KPortReserve : kernel version of portreserve utility
To: Vasily Kulikov <segoon@openwall.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, twaugh@redhat.com, amwang@redhat.com, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 8/7/2013 7:31 AM, Vasily Kulikov wrote:
> (CC'ed kernel-hardening)
>
> Hi Tetsuo,
>
> See my comments inlined,
>
> On Sat, Aug 03, 2013 at 17:15 +0900, Tetsuo Handa wrote:
>> Hello.
>>
>> There is a blog post regarding how to reliably reserve local port numbers at
>> http://cyberelk.net/tim/2012/02/15/portreserve-systemd-solution/ . Recently I
>> heard a trouble in a RHEL5 system where portreserve utility is not available.
>>
>> I wrote this trivial LSM module as a really race-proof solution. But I'm
>> expecting that this functionality becomes available in a way that all users can
>> use regardless of their skill to use SELinux/SMACK/TOMOYO/AppArmor.
>>
>> (Question 1) Should this functionality implemented as LSM module?
>> (Question 2) If yes, should this functionality implemented as a part of Yama?
>>
>> Regards.
>> --------------------
>> >From cbc76e3955e01dc6e590af860830b888ce7cbd0b Mon Sep 17 00:00:00 2001
>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Date: Sat, 3 Aug 2013 16:58:05 +0900
>> Subject: [PATCH] KPortReserve : kernel version of portreserve utility
>>
>> This module reserves local port like /proc/sys/net/ipv4/ip_local_reserved_ports
>> does, but this module is designed for stopping bind() requests with non-zero
>> local port numbers from unwanted programs.
>>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> ---
>>  security/Kconfig               |    6 +
>>  security/Makefile              |    2 +
>>  security/kportreserve/Kconfig  |   35 ++++
>>  security/kportreserve/Makefile |    1 +
>>  security/kportreserve/kpr.c    |  443 ++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 487 insertions(+), 0 deletions(-)
>>  create mode 100644 security/kportreserve/Kconfig
>>  create mode 100644 security/kportreserve/Makefile
>>  create mode 100644 security/kportreserve/kpr.c
>>
>> diff --git a/security/Kconfig b/security/Kconfig
>> index e9c6ac7..f4058ff 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -122,6 +122,7 @@ source security/smack/Kconfig
>>  source security/tomoyo/Kconfig
>>  source security/apparmor/Kconfig
>>  source security/yama/Kconfig
>> +source security/kportreserve/Kconfig
>>  
>>  source security/integrity/Kconfig
>>  
>> @@ -132,6 +133,7 @@ choice
>>  	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
>>  	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
>>  	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
>> +	default DEFAULT_SECURITY_KPR if SECURITY_KPR
>>  	default DEFAULT_SECURITY_DAC
>>  
>>  	help
>> @@ -153,6 +155,9 @@ choice
>>  	config DEFAULT_SECURITY_YAMA
>>  		bool "Yama" if SECURITY_YAMA=y
>>  
>> +	config DEFAULT_SECURITY_KPR
>> +		bool "KPortReserve" if SECURITY_KPR=y
>> +
>>  	config DEFAULT_SECURITY_DAC
>>  		bool "Unix Discretionary Access Controls"
>>  
>> @@ -165,6 +170,7 @@ config DEFAULT_SECURITY
>>  	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
>>  	default "apparmor" if DEFAULT_SECURITY_APPARMOR
>>  	default "yama" if DEFAULT_SECURITY_YAMA
>> +	default "kpr" if DEFAULT_SECURITY_KPR
>>  	default "" if DEFAULT_SECURITY_DAC
>>  
>>  endmenu
>> diff --git a/security/Makefile b/security/Makefile
>> index c26c81e..87f95cc 100644
>> --- a/security/Makefile
>> +++ b/security/Makefile
>> @@ -8,6 +8,7 @@ subdir-$(CONFIG_SECURITY_SMACK)		+= smack
>>  subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
>>  subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
>>  subdir-$(CONFIG_SECURITY_YAMA)		+= yama
>> +subdir-$(CONFIG_SECURITY_KPR)		+= kportreserve
>>  
>>  # always enable default capabilities
>>  obj-y					+= commoncap.o
>> @@ -23,6 +24,7 @@ obj-$(CONFIG_AUDIT)			+= lsm_audit.o
>>  obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
>>  obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
>>  obj-$(CONFIG_SECURITY_YAMA)		+= yama/built-in.o
>> +obj-$(CONFIG_SECURITY_KPR)		+= kportreserve/built-in.o
>>  obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
>>  
>>  # Object integrity file lists
>> diff --git a/security/kportreserve/Kconfig b/security/kportreserve/Kconfig
>> new file mode 100644
>> index 0000000..73ad5bc
>> --- /dev/null
>> +++ b/security/kportreserve/Kconfig
>> @@ -0,0 +1,35 @@
>> +config SECURITY_KPR
>> +	bool "KPortReserve support"
>> +	depends on SECURITY
>> +	depends on PROC_FS
>> +	select SECURITY_NETWORK
>> +	default n
>> +	help
>> +	  This selects local port reserving module which is similar to
>> +	  /proc/sys/net/ipv4/ip_local_reserved_ports . But this module is
>> +	  designed for stopping bind() requests with non-zero local port
>> +	  numbers from unwanted programs using white list reservations.
>> +	  
>> +	  If you are unsure how to answer this question, answer N.
>> +	  
>> +	  Usage:
>> +	  
>> +	  Use "add $port $program" format to add reservation.
>> +	  The $port is a single port number between 0 and 65535.
>> +	  The $program is the content of /proc/self/exe in TOMOYO's pathname
>> +	  representation rule (i.e. consists with only ASCII printable
>> +	  characters, and seen from the current thread's namespace's root (e.g.
>> +	  /var/chroot/bin/bash for /bin/bash running inside /var/chroot/
>> +	  chrooted environment)). The <kernel> means kernel threads).
>> +	  For example,
>> +	  
>> +	  # echo "add 10000 /bin/bash" > /proc/reserved_local_port
>> +	  # echo "add 20000 <kernel>" > /proc/reserved_local_port
>> +	  
>> +	  allows bind() on port 10000 to /bin/bash and allows bind() on port
>> +	  20000 to kernel threads.
> Wait, it restrict the port to a *program*, not a user/group/security
> domain?  It means *any* user may run this program and obtain the port.
> Is it intentional behaviour?  I guess it would be MUCH more useful to
> allow some port to this specific user, NOT a program.  For most daemons
> we have separate user accounts (SELinux contexts in some distros,
> whatever), so it makes sense to limit the port to a UID/GID (or LSM's
> security context).

Very 20th century thinking.

While the security community has been toying with program based
access controls for the past four decades (UNICOS had program access
lists in the 1990s) it wasn't until "Apps" hit phones that they
began to be taken seriously. Android used (co-opted, hijacked) the
UID to accomplish this. Some (but not all) aspects of SELinux policy
in Fedora identify the program and its standing within the system.
Both of these systems abuse security attributes that are not intended
to identify programs to do just that. This limits the legitimate use
of those attributes for their original purpose.

What Tetsuo is proposing is using the information he really cares
about (the program) rather than an attribute (UID, SELinux context,
Smack label) that can be associated with the program. Further, he
is using it in a way that does not interfere with the intended use
of UIDs, labels or any other existing security attribute.

Very 21st century thinking.

>> +	  
>> +	  Use "del $port $program" format to remove reservation.
>> +	  
>> +	  Note that only port numbers which have at least one reservation are
>> +	  checked by this module.
>> diff --git a/security/kportreserve/Makefile b/security/kportreserve/Makefile
>> new file mode 100644
>> index 0000000..6342521
>> --- /dev/null
>> +++ b/security/kportreserve/Makefile
>> @@ -0,0 +1 @@
>> +obj-$(CONFIG_SECURITY_KPR) := kpr.o
>> diff --git a/security/kportreserve/kpr.c b/security/kportreserve/kpr.c
>> new file mode 100644
>> index 0000000..7b19d32
>> --- /dev/null
>> +++ b/security/kportreserve/kpr.c
>> @@ -0,0 +1,443 @@
>> +/*
>> + * kpr.c - kernel version of portreserve.
>> + */
>> +#include <linux/security.h>
>> +#include <linux/proc_fs.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/net.h>
>> +#include <linux/inet.h>
>> +#include <linux/uaccess.h>
>> +#include <net/sock.h>
>> +#include <net/ip.h>
>> +#include <net/ipv6.h>
>> +
>> +/* Max length of a line. */
>> +#define MAX_LINE_LEN 16384
>> +
>> +/* Port numbers with at least one whitelist element exists. */
>> +static unsigned long reserved_port_map[65536 / BITS_PER_LONG];
>> +
>> +/* Whitelist element. */
>> +struct reserved_port_entry {
>> +	struct list_head list;
>> +	const char *exe;
>> +	u16 port;
>> +};
>> +/* List of whitelist elements. */
>> +static LIST_HEAD(reserved_port_list);
>> +
>> +/**
>> + * kpr_encode - Encode binary string to ascii string.
>> + *
>> + * @str: String in binary format.
>> + *
>> + * Returns pointer to @str in ascii format on success, NULL otherwise.
>> + *
>> + * This function uses kzalloc(), so caller must kfree() if this function
>> + * didn't return NULL.
>> + */
>> +static char *kpr_encode(const char *str)
>> +{
>> +	int i;
>> +	int len = 0;
>> +	const char *p = str;
>> +	char *cp;
>> +	char *cp0;
>> +	const int str_len = strlen(str);
>> +	for (i = 0; i < str_len; i++) {
>> +		const unsigned char c = p[i];
>> +		if (c == '\\')
>> +			len += 2;
>> +		else if (c > ' ' && c < 127)
>> +			len++;
>> +		else
>> +			len += 4;
>> +	}
>> +	len++;
>> +	cp = kzalloc(len, GFP_KERNEL);
>> +	if (!cp)
>> +		return NULL;
>> +	cp0 = cp;
>> +	p = str;
>> +	for (i = 0; i < str_len; i++) {
>> +		const unsigned char c = p[i];
>> +		if (c == '\\') {
>> +			*cp++ = '\\';
>> +			*cp++ = '\\';
>> +		} else if (c > ' ' && c < 127) {
>> +			*cp++ = c;
>> +		} else {
>> +			*cp++ = '\\';
>> +			*cp++ = (c >> 6) + '0';
>> +			*cp++ = ((c >> 3) & 7) + '0';
>> +			*cp++ = (c & 7) + '0';
>> +		}
>> +	}
>> +	return cp0;
>> +}
>> +
>> +/**
>> + * kpr_realpath - Returns realpath(3) of the given pathname but ignores chroot'ed root.
>> + *
>> + * @path: Pointer to "struct path".
>> + *
>> + * Returns the realpath of the given @path on success, NULL otherwise.
>> + *
>> + * This function uses kzalloc(), so caller must kfree() if this function
>> + * didn't return NULL.
>> + */
>> +static char *kpr_realpath(struct path *path)
>> +{
>> +	char *buf = NULL;
>> +	char *name = NULL;
>> +	unsigned int buf_len = PAGE_SIZE / 2;
>> +	while (1) {
>> +		char *pos;
>> +		buf_len <<= 1;
>> +		kfree(buf);
>> +		buf = kmalloc(buf_len, GFP_KERNEL);
>> +		if (!buf)
>> +			break;
>> +		pos = d_absolute_path(path, buf, buf_len);
>> +		if (IS_ERR(pos))
>> +			continue;
> d_absolute_path() may fail in case of not only ENOMEM, but also EINVAL.
> In this case you'll OOM the kernel with too big kmalloc().  buf_len
> should be limited with some (not too big) number.
>
>> +		name = kpr_encode(pos);
>> +		break;
>> +	}
>> +	kfree(buf);
>> +	return name;
>> +}
>> +
>> +/**
>> + * kpr_get_exe - Get kpr_realpath() of current process.
> Probably it should be called kpr_realpath_current() or
> current_kpr_realpath() then?
>
>> + *
>> + * Returns the kpr_realpath() of current process on success, NULL otherwise.
>> + *
>> + * This function uses kzalloc(), so the caller must kfree()
>> + * if this function didn't return NULL.
>> + */
>> +static const char *kpr_get_exe(void)
>> +{
>> +	struct mm_struct *mm = current->mm;
>> +	const char *cp = NULL;
>> +	if (current->flags & PF_KTHREAD)
>> +		return kstrdup("<kernel>", GFP_KERNEL);
>> +	if (mm) {
>> +		down_read(&mm->mmap_sem);
>> +		if (mm->exe_file)
>> +			cp = kpr_realpath(&mm->exe_file->f_path);
>> +		up_read(&mm->mmap_sem);
>> +	}
>> +	return cp;
>> +}
>> +
>> +/**
>> + * kpr_socket_bind - Check permission for bind().
>> + *
>> + * @sock:     Pointer to "struct socket".
>> + * @addr:     Pointer to "struct sockaddr".
>> + * @addr_len: Size of @addr.
>> + *
>> + * Returns 0 on success, negative value otherwise.
>> + */
>> +static int kpr_socket_bind(struct socket *sock, struct sockaddr *addr,
>> +			   int addr_len)
>> +{
>> +	const char *exe;
>> +	u16 port;
>> +	switch (sock->sk->sk_family) {
>> +	case PF_INET:
>> +	case PF_INET6:
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +	switch (sock->type) {
>> +	case SOCK_STREAM:
>> +	case SOCK_DGRAM:
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +	switch (addr->sa_family) {
>> +	case AF_INET:
>> +		if (addr_len < sizeof(struct sockaddr_in))
>> +			return 0;
>> +		port = ((struct sockaddr_in *) addr)->sin_port;
>> +		break;
>> +	case AF_INET6:
>> +		if (addr_len < SIN6_LEN_RFC2133)
>> +			return 0;
>> +		port = ((struct sockaddr_in6 *) addr)->sin6_port;
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +	port = ntohs(port);
>> +	if (!test_bit(port, reserved_port_map))
>> +		return 0;
>> +	exe = kpr_get_exe();
>> +	if (!exe) {
>> +		pr_warn("Unable to read /proc/self/exe . Rejecting bind(%u) request.\n",
>> +			port);
>> +		return -ENOMEM;
>> +	} else {
>> +		struct reserved_port_entry *ptr;
>> +		int ret = 0;
>> +		rcu_read_lock();
>> +		list_for_each_entry_rcu(ptr, &reserved_port_list, list) {
>> +			if (port != ptr->port)
>> +				continue;
>> +			if (strcmp(exe, ptr->exe)) {
>> +				ret = -EADDRINUSE;
>> +				continue;
>> +			}
>> +			ret = 0;
>> +			break;
>> +		}
>> +		rcu_read_unlock();
>> +		kfree(exe);
>> +		return ret;
>> +	}
>> +}
>> +
>> +/**
>> + * kpr_read - read() for /proc/reserved_local_port interface.
>> + *
>> + * @file:  Pointer to "struct file".
>> + * @buf:   Pointer to buffer.
>> + * @count: Size of @buf.
>> + * @ppos:  Offset of @file.
>> + *
>> + * Returns bytes read on success, negative value otherwise.
>> + */
>> +static ssize_t kpr_read(struct file *file, char __user *buf, size_t count,
>> +			loff_t *ppos)
>> +{
>> +	ssize_t copied = 0;
>> +	int error = 0;
>> +	int record = 0;
>> +	loff_t offset = 0;
>> +	char *data = vmalloc(MAX_LINE_LEN);
>> +	if (!data)
>> +		return -ENOMEM;
>> +	while (1) {
>> +		struct reserved_port_entry *ptr;
>> +		int i = 0;
>> +		data[0] = '\0';
>> +		rcu_read_lock();
>> +		list_for_each_entry_rcu(ptr, &reserved_port_list, list) {
>> +			if (i++ < record)
>> +				continue;
>> +			snprintf(data, MAX_LINE_LEN - 1, "%u %s\n", ptr->port,
>> +				 ptr->exe);
>> +			break;
>> +		}
>> +		rcu_read_unlock();
>> +		if (!data[0])
>> +			break;
>> +		for (i = 0; data[i]; i++) {
>> +			if (offset++ < *ppos)
>> +				continue;
>> +			if (put_user(data[i], buf)) {
>> +				error = -EFAULT;
>> +				break;
>> +			}
>> +			buf++;
>> +			copied++;
>> +			(*ppos)++;
>> +		}
>> +		record++;
>> +	}
>> +	vfree(data);
>> +	return copied ? copied : error;
>> +}
>> +
>> +/**
>> + * kpr_normalize_line - Format string.
>> + *
>> + * @buffer: The line to normalize.
>> + *
>> + * Returns nothing.
>> + *
>> + * Leading and trailing whitespaces are removed.
>> + * Multiple whitespaces are packed into single space.
>> + */
>> +static void kpr_normalize_line(unsigned char *buffer)
>> +{
>> +	unsigned char *sp = buffer;
>> +	unsigned char *dp = buffer;
>> +	bool first = true;
>> +	while (*sp && (*sp <= ' ' || *sp >= 127))
>> +		sp++;
>> +	while (*sp) {
>> +		if (!first)
>> +			*dp++ = ' ';
>> +		first = false;
>> +		while (*sp > ' ' && *sp < 127)
>> +			*dp++ = *sp++;
>> +		while (*sp && (*sp <= ' ' || *sp >= 127))
>> +			sp++;
>> +	}
>> +	*dp = '\0';
>> +}
>> +
>> +/**
>> + * kpr_find_entry - Find an existing entry.
>> + *
>> + * @port: Port number.
>> + * @exe:  Pathname. NULL for any.
>> + *
>> + * Returns pointer to existing entry if found, NULL otherwise.
>> + */
>> +static struct reserved_port_entry *kpr_find_entry(const u16 port,
>> +						  const char *exe)
>> +{
>> +	struct reserved_port_entry *ptr;
>> +	bool found = false;
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(ptr, &reserved_port_list, list) {
>> +		if (port != ptr->port)
>> +			continue;
>> +		if (exe && strcmp(exe, ptr->exe))
>> +			continue;
>> +		found = true;
>> +		break;
>> +	}
>> +	rcu_read_unlock();
>> +	return found ? ptr : NULL;
>> +}
>> +
>> +/**
>> + * kpr_update_entry - Update the list of whitelist elements.
>> + *
>> + * @data: Line of data to parse.
>> + *
>> + * Returns 0 on success, negative value otherwise.
>> + *
>> + * Caller holds a mutex to protect from concurrent updates.
>> + */
>> +static int kpr_update_entry(const char *data)
>> +{
>> +	struct reserved_port_entry *ptr;
>> +	unsigned int port;
>> +	if (sscanf(data, "add %u", &port) == 1 && port < 65536) {
>> +		const char *cp = strchr(data + 4, ' ');
>> +		if (!cp++ || strchr(cp, ' '))
>> +			return -EINVAL;
>> +		if (kpr_find_entry(port, cp))
>> +			return 0;
>> +		ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
>> +		if (!ptr)
>> +			return -ENOMEM;
>> +		ptr->port = (u16) port;
>> +		ptr->exe = kstrdup(cp, GFP_KERNEL);
>> +		if (!ptr->exe) {
>> +			kfree(ptr);
>> +			return -ENOMEM;
>> +		}
>> +		list_add_tail_rcu(&ptr->list, &reserved_port_list);
>> +		set_bit(ptr->port, reserved_port_map);
>> +	} else if (sscanf(data, "del %u", &port) == 1 && port < 65536) {
>> +		const char *cp = strchr(data + 4, ' ');
>> +		if (!cp++ || strchr(cp, ' '))
>> +			return -EINVAL;
>> +		ptr = kpr_find_entry(port, cp);
>> +		if (!ptr)
>> +			return 0;
>> +		list_del_rcu(&ptr->list);
>> +		synchronize_rcu();
>> +		kfree(ptr->exe);
>> +		kfree(ptr);
>> +		if (!kpr_find_entry(port, NULL))
>> +			clear_bit(ptr->port, reserved_port_map);
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +	return 0;
>> +}
>> +
>> +/**
>> + * kpr_write - write() for /proc/reserved_local_port interface.
>> + *
>> + * @file:  Pointer to "struct file".
>> + * @buf:   Domainname to transit to.
>> + * @count: Size of @buf.
>> + * @ppos:  Unused.
>> + *
>> + * Returns bytes parsed on success, negative value otherwise.
>> + */
>> +static ssize_t kpr_write(struct file *file, const char __user *buf,
>> +			 size_t count, loff_t *ppos)
>> +{
>> +	char *data;
>> +	ssize_t copied = 0;
>> +	int error;
>> +	if (!count)
>> +		return 0;
>> +	if (count > MAX_LINE_LEN - 1)
>> +		count = MAX_LINE_LEN - 1;
>> +	data = vmalloc(count + 1);
>> +	if (!data)
>> +		return -ENOMEM;
>> +	if (copy_from_user(data, buf, count)) {
>> +		error = -EFAULT;
>> +		goto out;
>> +	}
>> +	data[count] = '\0';
>> +	while (1) {
>> +		static DEFINE_MUTEX(lock);
>> +		char *cp = strchr(data, '\n');
>> +		int len;
>> +		if (!cp) {
>> +			error = -EINVAL;
>> +			break;
>> +		}
>> +		*cp = '\0';
>> +		len = strlen(data) + 1;
>> +		kpr_normalize_line(data);
>> +		if (mutex_lock_interruptible(&lock)) {
>> +			error = -EINTR;
>> +			break;
>> +		}
>> +		error = kpr_update_entry(data);
>> +		mutex_unlock(&lock);
>> +		if (error < 0)
>> +			break;
>> +		copied += len;
>> +		memmove(data, data + len, strlen(data + len) + 1);
>> +	}
>> +out:
>> +	vfree(data);
>> +	return copied ? copied : error;
>> +}
>> +
>> +/* List of hooks. */
>> +static struct security_operations kpr_ops = {
>> +	.name        = "kpr",
>> +	.socket_bind = kpr_socket_bind,
>> +};
>> +
>> +/* Operations for /proc/reserved_local_port interface. */
>> +static const struct file_operations kpr_operations = {
>> +	.write = kpr_write,
>> +	.read  = kpr_read,
>> +};
>> +
>> +/**
>> + * kpr_init - Initialize this module.
>> + *
>> + * Returns 0 on success, negative value otherwise.
>> + */
>> +static int __init kpr_init(void)
>> +{
>> +	if (!security_module_enable(&kpr_ops))
>> +		return 0;
>> +	if (!proc_create("reserved_local_port", 0644, NULL, &kpr_operations) ||
>> +	    register_security(&kpr_ops))
>> +		panic("Failure registering kportreserve");
>> +	pr_info("KPortReserve initialized\n");
>> +	return 0;
>> +}
>> +
>> +late_initcall(kpr_init);
>> -- 
>> 1.7.1
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Thanks,
>
