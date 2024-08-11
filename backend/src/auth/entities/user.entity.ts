import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  Index,
  BeforeInsert,
  BeforeUpdate,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
} from 'typeorm';
import * as bcrypt from 'bcrypt';

@Entity({
  name: 'user',
})
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  password: string;
  @Column({ unique: true })
  @Index()
  phone!: string;

  @Column()
  firstName!: string;

  @Column()
  lastName?: string;

  @Column({
    default: '',
  })
  bio: string;

  @Column({
    nullable: true,
  })
  lastLogin: Date;

  @DeleteDateColumn()
  deletedAt?: Date;

  @CreateDateColumn({
    type: 'timestamp',
    nullable: true,
    default: () => 'CURRENT_TIMESTAMP(6)',
  })
  created: Date;

  @UpdateDateColumn({
    type: 'timestamp',
    nullable: true,
    default: () => 'CURRENT_TIMESTAMP(6)',
    onUpdate: 'CURRENT_TIMESTAMP(6)',
  })
  updated: Date;
  // Encrypt password before inserting or updating user
  @BeforeInsert()
  @BeforeUpdate()
  async hashPassword() {
    // console.log('Hashing password', this.password);
    if (this.password) {
      const saltRounds = 5; // reduce hash rounds
      this.password = await bcrypt.hash(this.password, saltRounds);
    }
  }
}
